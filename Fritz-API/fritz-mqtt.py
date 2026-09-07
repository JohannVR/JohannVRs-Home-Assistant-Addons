import datetime
import json
import logging
import os
import signal
import sys
import time
import xml.etree.ElementTree as ET
import paho.mqtt.client as mqtt
import requests
from requests.auth import HTTPDigestAuth

# 1. Parse configuration safely using Home Assistant's standard options file
OPTIONS_PATH = "/data/options.json"

if not os.path.exists(OPTIONS_PATH):
    print(f"Error: Configuration file not found at {OPTIONS_PATH}. Is this running as a HA Add-on?")
    exit(1)

with open(OPTIONS_PATH, "r") as f:
    options = json.load(f)

FRITZ_IP = options.get("repeater_ip")
REPEATER_LOGIN = options.get("repeater_login", "")
REPEATER_PASSWORD = options.get("repeater_password", "")

MQTT_IP = options.get("mqtt_ip")
MQTT_PORT = options.get("mqtt_port", 1883)
MQTT_USER = options.get("mqtt_user")
MQTT_PASSWORD = options.get("mqtt_password")

TARGET_MACS = options.get("device_mac_list", [])
TOPICS = options.get("device_name_list", [])

LOG_LEVEL_NAME = str(options.get("log_level", "INFO")).upper()
LOG_LEVEL = getattr(logging, LOG_LEVEL_NAME, logging.INFO)

# 2. Logging setup - timestamped, leveled, and sent to stdout so it shows up
# cleanly in the Home Assistant add-on log viewer (which timestamps lines itself
# for supervisor logs, but this keeps things readable if viewed via `docker logs`
# or when the supervisor's own timestamp is stripped out).
logging.basicConfig(
    level=LOG_LEVEL,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    stream=sys.stdout,
)
logger = logging.getLogger("fritz-mqtt")

if LOG_LEVEL_NAME not in logging._nameToLevel:
    logger.warning(f"Unknown log_level '{LOG_LEVEL_NAME}' in options, defaulting to INFO.")

if len(TOPICS) != len(TARGET_MACS):
    logger.error("Configuration Error: 'device_name_list' and 'device_mac_list' must have the exact same number of items.")
    exit(1)

# FRITZ!OS requires authentication for TR-064 calls by default. Without credentials,
# the router replies with an HTTP 500 wrapping a SOAP Fault (commonly UPnPError 401
# "Unauthenticated") rather than a plain 401 - which is why this can look like a
# generic server error in the logs if repeater_login/repeater_password aren't set.
FRITZ_AUTH = HTTPDigestAuth(REPEATER_LOGIN, REPEATER_PASSWORD) if REPEATER_LOGIN else None
if FRITZ_AUTH is None:
    logger.warning("No repeater_login configured - TR-064 requests will be sent unauthenticated.")

# 3. Setup MQTT Client
client = mqtt.Client(callback_api_version=mqtt.CallbackAPIVersion.VERSION2)
if MQTT_USER and MQTT_PASSWORD:
    client.username_pw_set(MQTT_USER, MQTT_PASSWORD)
client.reconnect_delay_set(min_delay=1, max_delay=30)

def on_connect(client, userdata, flags, reason_code, properties=None):
    if reason_code == 0:
        logger.info(f"Connected to MQTT broker at {MQTT_IP}:{MQTT_PORT}.")
    else:
        logger.error(f"MQTT connection failed: {reason_code}")

def on_disconnect(client, userdata, flags, reason_code, properties=None):
    if reason_code == 0:
        logger.info("Disconnected from MQTT broker.")
    else:
        logger.warning(f"Unexpected MQTT disconnect ({reason_code}). Will attempt to reconnect.")

client.on_connect = on_connect
client.on_disconnect = on_disconnect

def send_state(state, topic, device_name):
    try:
        client.publish(topic, state, qos=1, retain=True)
        logger.debug(f"Published '{state}' to {topic}")
    except Exception as e:
        logger.error(f"MQTT publish error for {device_name} ({topic}): {e}")

session = requests.Session()

def describe_soap_fault(response_text):
    """Try to pull a UPnP error code/description out of a SOAP Fault body for clearer logs."""
    try:
        root = ET.fromstring(response_text)
        code = root.find(".//errorCode")
        desc = root.find(".//errorDescription")
        if code is not None:
            return f"UPnPError {code.text}" + (f" ({desc.text})" if desc is not None else "")
    except Exception:
        pass
    return None

def is_device_active(mac, ip_address):
    url = f"http://{ip_address}:49000/upnp/control/hosts"
    headers = {
        "Content-Type": 'text/xml; charset="utf-8"',
        "SOAPACTION": '"urn:dslforum-org:service:Hosts:1#GetSpecificHostEntry"',
        "User-Agent": "AVM UPnP/1.0 Client 1.0"
    }
    data = f"""<?xml version="1.0" encoding="utf-8"?>
    <s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" >
    <s:Body>
        <u:GetSpecificHostEntry xmlns:u="urn:dslforum-org:service:Hosts:1">
            <NewMACAddress>{mac}</NewMACAddress>
        </u:GetSpecificHostEntry>
    </s:Body>
    </s:Envelope>"""
    try:
        response = session.post(url, headers=headers, data=data, timeout=5, auth=FRITZ_AUTH)
        response.raise_for_status()
        root = ET.fromstring(response.text)
        active_el = root.find(".//NewActive")
        return active_el is not None and active_el.text == "1"
    except requests.exceptions.HTTPError as e:
        fault = describe_soap_fault(e.response.text) if e.response is not None else None
        if fault:
            raise RuntimeError(f"Fritzbox API error: {e} - {fault}")
        raise RuntimeError(f"Fritzbox API error: {e}")
    except Exception as e:
        raise RuntimeError(f"Fritzbox API error: {e}")

# 4. Graceful shutdown handling
shutdown_requested = False

def handle_shutdown(signum, frame):
    global shutdown_requested
    logger.info(f"Received signal {signum}, finishing current cycle and disconnecting...")
    shutdown_requested = True

signal.signal(signal.SIGTERM, handle_shutdown)
signal.signal(signal.SIGINT, handle_shutdown)

def interruptible_sleep(seconds):
    """Sleep in 1s increments so a shutdown signal is honored promptly instead of
    waiting out the full poll interval."""
    for _ in range(seconds):
        if shutdown_requested:
            return
        time.sleep(1)

# Connect to MQTT
# connect_async() + loop_start() (rather than a synchronous connect()) ensures paho
# keeps retrying in the background even if the very first connection attempt fails,
# instead of only retrying reconnects after a connection that once succeeded.
logger.info(f"Connecting to MQTT Broker: {MQTT_IP}:{MQTT_PORT}...")
try:
    client.connect_async(MQTT_IP, MQTT_PORT, 60)
except Exception as e:
    logger.warning(f"MQTT connection setup failed: {e}. Will retry automatically.")

client.loop_start()

# Build device structural state tracking
devices = []
for name, mac in zip(TOPICS, TARGET_MACS):
    devices.append({
        "name": name,
        "mac": mac,
        "is_home": None,       # unknown until the first successful check
        "initialized": False,  # becomes True once the startup state has been published
        "fail_count": 0,
        "mqtt_topic": f"fritzapi_connection/{name}"
    })

logger.info(f"Fritzbox MQTT Monitor Add-on started, tracking {len(devices)} device(s).")

consecutive_errors = 0

# Main loop
while not shutdown_requested:
    for device in devices:
        # Each device is isolated: one device's API error no longer skips the
        # rest of the devices for this cycle.
        try:
            active = is_device_active(device["mac"], FRITZ_IP)
        except Exception as e:
            consecutive_errors += 1
            logger.warning(f"{device['name']}: check failed ({e})")
            if consecutive_errors >= 10:
                logger.error(f"Continuous API failures tracking router. Last error: {e}")
                consecutive_errors = 0
            continue

        consecutive_errors = 0
        logger.debug(f"{device['name']}: poll result active={active}")

        if not device["initialized"]:
            # First successful check for this device: publish its state right away
            # (this is what gives us the "send all states on startup" behavior),
            # then switch to change-only publishing from here on.
            state = "home" if active else "not_home"
            send_state(state, device["mqtt_topic"], device["name"])
            device["is_home"] = active
            device["fail_count"] = 0
            device["initialized"] = True
            logger.info(f"{device['name']}: initial state {state.upper()}")
            continue

        if active:
            device["fail_count"] = 0
            if not device["is_home"]:
                send_state("home", device["mqtt_topic"], device["name"])
                logger.info(f"{device['name']} marked as HOME")
                device["is_home"] = True
        else:
            if device["fail_count"] < 3:
                device["fail_count"] += 1

            if device["fail_count"] == 3:
                if device["is_home"]:
                    send_state("not_home", device["mqtt_topic"], device["name"])
                    logger.info(f"{device['name']} marked as NOT_HOME")
                    device["is_home"] = False

    interruptible_sleep(30)

# Clean shutdown
logger.info("Disconnecting from MQTT and exiting.")
client.loop_stop()
client.disconnect()
sys.exit(0)

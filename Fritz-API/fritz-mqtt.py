import paho.mqtt.client as mqtt
import datetime
import requests
import time

### import config
f = open("/data/options.json", "r")
options = f.read()


FRITZ_IP = options.split('"repeater_ip": "')[1].split('"')[0]
MQTT_IP = options.split('"mqtt_ip": "')[1].split('"')[0]
MQTT_USER = options.split('"mqtt_user": "')[1].split('"')[0]
MQTT_PASSWORD = options.split('"mqtt_password": "')[1].split('"')[0]
TOPICS = [item.strip() for item in (options.split('"device_name_list": "')[1].split('"')[0].split(","))]
TARGET_MACS = [item.strip() for item in (options.split('"device_mac_list": "')[1].split('"')[0].split(","))]


client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
client.username_pw_set(MQTT_USER, MQTT_PASSWORD)

if client.connect(MQTT_IP, 1883, 60) != 0:
    print("Couldn't connect to the mqtt broker")

def send_state(state, topic):
    client.publish(topic, state, 0, True)

def send_with_auth(mac, ip_address):
    devices = []
    url = "http://" + str(ip_address) + ":49000/upnp/control/hosts"
    headers = {
    "Content-Type": 'text/xml; charset="utf-8"',
    "SOAPACTION": f'"urn:dslforum-org:service:Hosts:1#GetSpecificHostEntry"',
    "User-Agent": "AVM UPnP/1.0 Client 1.0"
    }

    data = f"""<?xml version="1.0" encoding="utf-8"?>
    <s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"
    xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" >
    <s:Header>
    <h:InitChallenge
    xmlns:h="http://soap-authentication.org/digest/2001/10/"
    s:mustUnderstand="1">
    </h:InitChallenge >
    </s:Header>
    <s:Body>
        <u:GetSpecificHostEntry xmlns:u="urn:dslforum-org:service:Hosts:1">
            <NewMACAddress>{mac}</NewMACAddress>
        </u:GetSpecificHostEntry>
    </s:Body>
    </s:Envelope>"""

    response = requests.post(url, headers=headers, data=data)
    if response.text.split("<NewActive>")[1].split("</NewActive>")[0] == "1":
        return(True)
    else:
        return(False)
    
people = []
    
for i in range(len(TOPICS)):
    people.append([TOPICS[i], (send_with_auth(TARGET_MACS[i], FRITZ_IP)), 0])
    print("current state: " + str(people[i][0]) + " = " + str(people[i][1]))
time.sleep(5)

errors = 0

while True:
    try:
        for i in range(len(TARGET_MACS)):
            if send_with_auth(TARGET_MACS[i], FRITZ_IP) == True:
                send_state("home", "fritzapi_connection/" + TOPICS[i])
                people[i][2] = 0
                if (people[i][1] == False):
                    print(str(TOPICS[i]) + " connected at " + datetime.datetime.now().strftime("%H:%M on the %d.%m.%Y"))
                    people[i][1] = True
            if send_with_auth(TARGET_MACS[i], FRITZ_IP) == False:
                if people[i][2] < 3:
                    people[i][2] += 1
                if people[i][2] == 3:
                    send_state("not_home", "fritzapi_connection/" + TOPICS[i])
                    if (people[i][1] == True):
                        print(str(TOPICS[i]) + " disconnected at " + datetime.datetime.now().strftime("%H:%M on the %d.%m.%Y"))
                        people[i][1] = False
            time.sleep(1)
        errors = 0
    except:
        errors += 1
        if errors == 11:
            print("failed to call API over 10 times...")
            errors = 0
    time.sleep(30)

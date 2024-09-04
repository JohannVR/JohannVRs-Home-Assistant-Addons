from fritzconnection import FritzConnection
import paho.mqtt.client as mqtt
import requests
import json
import time

### import config
f = open("/data/options.json", "r")
options = f.read()


FRITZ_IP = options.split('"repeater_ip": "')[1].split('"')[0]
FRITZ_USER = options.split('"repeater_login": "')[1].split('"')[0]
FRITZ_PW = options.split('"repeater_password": "')[1].split('"')[0]
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
    client.publish(topic, state, 0)


def get_endpoint():
    fc = FritzConnection(address=FRITZ_IP, user=FRITZ_USER, password=FRITZ_PW)
    endpoint = fc.call_action("WLANConfiguration1", "X_AVM-DE_GetWLANDeviceListPath")
    return(endpoint["NewX_AVM-DE_WLANDeviceListPath"])

endpoint = get_endpoint()

print(endpoint)

while True:
    try:
        res = requests.get('http://' + FRITZ_IP + ':49000' + endpoint, auth=(FRITZ_USER, FRITZ_PW))

        devices = res.text.split("<Item>")
    except:
        print("error... getting new endpoint")
        try:
            endpoint = get_endpoint()
        except:
            print("error connecting to fritzbox")

    for m in range(len(TOPICS)):
        found = 0
        for i in range(len(devices)):
            if devices[i].find(TARGET_MACS[m]) != -1:
                found = 1
                print(str(TOPICS[m]) + " is connected at: " + str(i))
                send_state("home", "fritzapi_connection/" + TOPICS[m])
        if found == 0:
            print("not connected")
            send_state("not_home", "fritzapi_connection/" + TOPICS[m])


    time.sleep(60)

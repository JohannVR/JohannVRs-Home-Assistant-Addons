# Fritz 1200 Device Tracker

This Home Assistant addon uses the build-in API of the Fritz 1200 to check connected devices. Tracked devices will be exposed via MQTT.

### Key Features:

* **Multiple Devices:** Tracks all devices you provide the MAC address of.
* **MQTT:** Exposes listed devices as MQTT entries under the topic ```"fritzapi_connection/{device name}"```

Example for device name ```"johann"```:

```
mqtt:
  - device_tracker:
      name: "johanns_iphone"
      state_topic: "fritzapi_connection/johann"
      source_type: router
```


Here's more of my work:
`https://github.com/JohannVR/JohannVRs-Home-Assistant-Addons`

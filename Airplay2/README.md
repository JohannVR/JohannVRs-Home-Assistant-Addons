# Airplay 2

This Home Assistant addon allows your device to function as an AirPlay 2 receiver.
Stream audio directly from your iPhone, iPad, or Mac to speakers connected to your Home Assistant setup.

<img width=25% src="logo.png">

### Key Features:

* **AirPlay 2 Compatibility:** Play audio from Apple devices on your Home Assistant system.
* **MQTT Integration:** Sends out status reports to the "airplay2" topic when enabled. Check out the [docs](https://github.com/mikebrady/shairport-sync/blob/master/MQTT.md).

### Technical Notes:

* **Shairport-Sync:** Utilizes the [Shairport-Sync](https://github.com/mikebrady/shairport-sync) library by mikebrady for AirPlay 2 functionality.
* **Debian Container:** Built using a Debian image (may be larger than some addons).

##### Installation

To install this addon, you must first add its repository URL to your Home Assistant instance.
To do so, add the repository URL below to the Home Assistant add-on store:

`https://github.com/JohannVR/JohannVRs-Home-Assistant-Addons`


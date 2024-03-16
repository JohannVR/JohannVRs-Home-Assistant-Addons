# Airplay 2

This Home Assistant addon allows your device to function as an AirPlay 2 receiver.
Stream audio directly from your iPhone, iPad, or Mac to speakers connected to your Home Assistant setup.

### Key Features:

* **AirPlay 2 Compatibility:** Play audio from Apple devices on your Home Assistant system.
* **MQTT Integration:** Sends out status reports to the "airplay2" topic when enabled. Check out the [docs](https://github.com/mikebrady/shairport-sync/blob/master/MQTT.md).

### Technical Notes:

* **Shairport-Sync:** Utilizes the [Shairport-Sync](https://github.com/mikebrady/shairport-sync) library by mikebrady for AirPlay 2 functionality.
* **Debian Container:** Built using a Debian container (may be larger than some addons). Future updates may explore smaller image sizes for faster installation.
* **Initial Setup Time:** The initial installation may take longer due to the image building process.

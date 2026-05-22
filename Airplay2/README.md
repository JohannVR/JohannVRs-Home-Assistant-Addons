# Airplay 2

This Home Assistant addon allows your device to function as an AirPlay 2 receiver.
Stream audio directly from your iPhone, iPad, or Mac to speakers connected to your Home Assistant setup.

<img width=25% src="logo.png">

### Key Features:

* **AirPlay 2 Compatibility:** Play audio from Apple devices on your Home Assistant system.
* **MQTT Integration:** Sends out status reports to the "airplay2" topic when enabled. Check out the [docs](https://github.com/mikebrady/shairport-sync/blob/master/MQTT.md).

### Why use this? (Example Use Cases)

Instead of buying expensive standalone AirPlay speakers, this add-on lets you repurpose your existing hardware and integrate your audio directly into your smart home ecosystem.
* **The "Dumb" Speaker Upgrade**: Have an old, great-sounding stereo system or bookshelf speakers? Plug a cheap USB sound card or a 3.5mm jack from your HA Host (e.g. Raspberry Pi) into the stereo's AUX port. Your vintage speakers are now a modern AirPlay 2 target.
* **Whole-House Smart Audio**: If you run Home Assistant on a mini-PC or Pi connected to a speaker in your kitchen, livingroom, etc, you can syncronize the playback with other Airplay 2 speaker around your home.
* **Automate Your Audio Gear**: Because this add-on integrates with MQTT, Home Assistant instantly knows when you start streaming. You can create automations like:
    * "When I connect to AirPlay in the living room, turn on the smart plug attached to the amplifier and set the volume to 30%."
    * "When the stream stops for more than 5 minutes, turn the amplifier off to save power."

### Technical Notes:

* **Shairport-Sync:** Utilizes the [Shairport-Sync](https://github.com/mikebrady/shairport-sync) library by mikebrady for AirPlay 2 functionality.
* **Alpine Container:** Built using the official Shairport-sync image, which is Alpine-based.

##### Installation

To install this addon, you must first add its repository URL to your Home Assistant instance.
To do so, add the repository URL below to the Home Assistant add-on store:

`https://github.com/JohannVR/JohannVRs-Home-Assistant-Addons`

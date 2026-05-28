#!/bin/sh

CONFIG_PATH="/data/options.json"
TEMPLATE_PATH="/etc/shairport-sync.conf.tpl"
OUTPUT_PATH="/etc/shairport-sync.conf"

if [ -f "$CONFIG_PATH" ]; then
    echo "Loading configuration from $CONFIG_PATH..."

    # Export JSON keys as environment variables
    eval $(jq -r 'to_entries | .[] | "export \(.key)=\"\(.value)\""' "$CONFIG_PATH")

    echo "Environment variables exported."

    # Set defaults
    export mqtt_topic="${mqtt_topic:=airplay2}"
    export mqtt_publish_parsed="${mqtt_publish_parsed:=yes}"
    export mqtt_enable_remote="${mqtt_enable_remote:=no}"
    export volume_max_db="${volume_max_db:=0.0}"
    export output_format="${output_format:=auto}"
    export output_rate="${output_rate:=auto}"
    export use_precision_timing="${use_precision_timing:=auto}"
    export disable_standby_mode="${disable_standby_mode:=never}"
    export mixer_control_name="${mixer_control_name:=PCM}"
    export mixer_control_index="${mixer_control_index:=0}"
    export volume_control_combined_hardware_priority="${volume_control_combined_hardware_priority:=no}"
    export drift_tolerance_in_seconds="${drift_tolerance_in_seconds:=0.002}"
    export resync_threshold_in_seconds="${resync_threshold_in_seconds:=0.050}"

else
    echo "Error: $CONFIG_PATH not found."
    exit 1
fi

# Run envsubst to generate the final config file
if [ -f "$TEMPLATE_PATH" ]; then
    echo "Rendering $TEMPLATE_PATH -> $OUTPUT_PATH..."
    envsubst < "$TEMPLATE_PATH" > "$OUTPUT_PATH"
    echo "Success! Configuration generated."
else
    echo "Error: Template $TEMPLATE_PATH not found."
    exit 1
fi

echo "Removing syslogd from s6-overlay to prevent conflicts..."

# Löscht alle syslogd Verzeichnisse, falls sie existieren
if [ -d /etc/s6-overlay/s6-rc.d ] && ls /etc/s6-overlay/s6-rc.d/syslogd* >/dev/null 2>&1; then
    rm -rf /etc/s6-overlay/s6-rc.d/syslogd*
    echo "Syslogd service directories removed."
fi

# Löscht die Bundle-Referenz nur, wenn die Datei existiert
if [ -f /etc/s6-overlay/s6-rc.d/user/contents.d/syslogd-bundle ]; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/syslogd-bundle
    echo "Syslogd-bundle reference removed from user contents."
fi

exec /init ./run.sh

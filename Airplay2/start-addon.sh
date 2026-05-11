#!/bin/sh

CONFIG_PATH="/data/options.json"
TEMPLATE_PATH="/etc/shairport-sync.conf.tpl"
OUTPUT_PATH="/etc/shairport-sync.conf"

if [ -f "$CONFIG_PATH" ]; then
    echo "Loading configuration from $CONFIG_PATH..."

    # Export JSON keys as environment variables
    eval $(jq -r 'to_entries | .[] | "export \(.key)=\"\(.value)\""' "$CONFIG_PATH")

    echo "Environment variables exported."
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

exec /run.sh

#!/bin/bash

# Get arguments
config_file="/etc/shairport-sync.conf"
json_file="/data/options.json"
json_key="airplay_name"

# Extract value from JSON using jq
value=$(jq -r ".$json_key" "$json_file")

# Check if value extraction was successful
if [ $? -ne 0 ]; then
  echo "Error: Could not extract value from JSON using key '$json_key'."
  exit 1
fi

# Escape backslashes and dollar signs for safe sed usage
escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')
quoted_value="\"$escaped_value\""

# Replace line in config file using sed (target 9th line)
sed -i "9s/.*/        name = $quoted_value/" "$config_file"

# Inform user
echo "Replaced line 9 in '$config_file' with 'name = $value'."
#!/bin/bash

FILE=/data/options.json
if test -f "$FILE"; then

# Setting Files
config_file="/etc/shairport-sync.conf"
json_file="/data/options.json"

################################################### Name ###################################################

# Get arguments
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

################################################### offset ###################################################

# Get arguments
json_key="offset"

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
sed -i "72s/.*/        audio_backend_latency_offset_in_seconds = $quoted_value/" "$config_file"

################################################### mqtt setting ###################################################

# Get arguments
json_key="enabled"

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
sed -i "271s/.*/        enabled = $quoted_value/" "$config_file"

################################################### mqtt hostname ###################################################

# Get arguments
json_key="mqtt_host"

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
sed -i "272s/.*/        hostname = $quoted_value/" "$config_file"

################################################### mqtt username ###################################################

# Get arguments
json_key="mqtt_username"

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
sed -i "274s/.*/        username = $quoted_value/" "$config_file"

################################################### mqtt password ###################################################

# Get arguments
json_key="mqtt_password"

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
sed -i "275s/.*/        password = $quoted_value/" "$config_file"

################################################### mqtt publish cover ###################################################

# Get arguments
json_key="mqtt_publish_cover"

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
sed -i "287s/.*/        publish_cover = $quoted_value/" "$config_file"

################################################### audio backend ###################################################

# Replace line in config file using sed (target 9th line)
sed -i "19s/.*/        output_backend = \"pa\"/" "$config_file"

##########################
fi

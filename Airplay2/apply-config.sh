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

# Replace line in config file using sed (target 72nd line)
sed -i "72s/.*/        audio_backend_latency_offset_in_seconds = $escaped_value/" "$config_file"

################################################### interpolation ###################################################

# Get arguments
json_key="interpolation"

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

# Replace line in config file using sed (target 18th line)
sed -i "18s/.*/        interpolation =  $quoted_value/" "$config_file"

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

# Replace line in config file using sed (target 273st line)
sed -i "273s/.*/        enabled = $quoted_value/" "$config_file"

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

# Replace line in config file using sed (target 274nd line)
sed -i "274s/.*/        hostname = $quoted_value/" "$config_file"

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

# Replace line in config file using sed (target 276th line)
sed -i "276s/.*/        username = $quoted_value/" "$config_file"

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

# Replace line in config file using sed (target 277th line)
sed -i "277s/.*/        password = $quoted_value/" "$config_file"

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

# Replace line in config file using sed (target 289th line)
sed -i "289s/.*/        publish_cover = $quoted_value/" "$config_file"

################################################### audio backend ###################################################
# Get arguments
json_key="output_backend"

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

# Replace line in config file using sed (target 19th line)
sed -i "19s/.*/        output_backend = $quoted_value/" "$config_file"

################################################### default_airplay_volume ###################################################
# Get arguments
json_key="default_airplay_volume"

# Extract value from JSON using jq
value=$(jq -r ".$json_key" "$json_file")

# Check if value extraction was successful
if [ $? -ne 0 ]; then
  echo "Error: Could not extract value from JSON using key '$json_key'."
  exit 1
fi

# Escape backslashes and dollar signs for safe sed usage
escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')

# Replace line in config file using sed (target 54th line)
sed -i "54s/.*/        default_airplay_volume = $escaped_value;/" "$config_file"


################################################### volume_max_db ###################################################
json_key="volume_max_db"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')

  sed -i "39s/.*/        volume_max_db = $escaped_value;/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

################################################### output_format ###################################################
json_key="output_format"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')
  quoted_value="\"$escaped_value\""

  sed -i "131s/.*/        output_format = $quoted_value;/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

################################################### output_rate ###################################################
json_key="output_rate"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')
  quoted_value="\"$escaped_value\""

  sed -i "130s/.*/        output_rate = $quoted_value;/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

################################################### use_precision_timing ###################################################
json_key="use_precision_timing"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')
  quoted_value="\"$escaped_value\""

  sed -i "140s/.*/        use_precision_timing =  $quoted_value/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

################################################### disable_standby_mode ###################################################
json_key="disable_standby_mode"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')
  quoted_value="\"$escaped_value\""

  sed -i "142s/.*/        disable_standby_mode =  $quoted_value/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

################################################### high_threshold_airplay_volume ###################################################
json_key="high_threshold_airplay_volume"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')

  sed -i "63s/.*/        high_threshold_airplay_volume = $escaped_value;/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi


################################################### mixer_control_name ###################################################
json_key="mixer_control_name"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')
  quoted_value="\"$escaped_value\""

  sed -i "126s/.*/        mixer_control_name = $quoted_value;/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

################################################### mixer_control_index ###################################################
json_key="mixer_control_index"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')

  sed -i "127s/.*/        mixer_control_index = $escaped_value;/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

################################################### volume_control_combined_hardware_priority ###################################################
json_key="volume_control_combined_hardware_priority"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')
  quoted_value="\"$escaped_value\""

  sed -i "52s/.*/        volume_control_combined_hardware_priority = $quoted_value;/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

################################################### drift_tolerance_in_seconds ###################################################
json_key="drift_tolerance_in_seconds"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')

  sed -i "29s/.*/        drift_tolerance_in_seconds = $escaped_value;/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

################################################### resync_threshold_in_seconds ###################################################
json_key="resync_threshold_in_seconds"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')

  sed -i "30s/.*/        resync_threshold_in_seconds = $escaped_value;/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

################################################### resync_recovery_time_in_seconds ###################################################
json_key="resync_recovery_time_in_seconds"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')

  sed -i "31s/.*/        resync_recovery_time_in_seconds = $escaped_value;/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

################################################### audio_backend_buffer_desired_length_in_seconds ###################################################
json_key="audio_backend_buffer_desired_length_in_seconds"

value=$(jq -r --arg key "$json_key" '.[$key] // empty' "$json_file")

if [ -n "$value" ]; then
  escaped_value=$(echo "$value" | sed 's/\\//g' | sed 's/\$/\\\\$/g')

  sed -i "76s/.*/        audio_backend_buffer_desired_length_in_seconds = $quoted_value;/" "$config_file"
else
  echo "Warning: Key '$json_key' not found in JSON. Skipping configuration update."
fi

##########################
fi

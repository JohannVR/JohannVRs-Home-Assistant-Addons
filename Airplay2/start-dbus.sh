#!/bin/bash

# Define the process name
PROCESS_NAME="dbus-daemon"

while true; do
    # Check if the process is running
    if pgrep -x "$PROCESS_NAME" > /dev/null; then
        echo "Process $PROCESS_NAME is already running."
    else
        # If not running, start the process
        echo "Process $PROCESS_NAME is not running. Starting it..."
        # Replace the command below with the command to start your process
        # Example: /path/to/your/process/executable &
        # The '&' at the end runs the process in the background
        /etc/init.d/dbus start &
    fi

    # Sleep for a certain duration before checking again
    sleep 5  # Adjust the duration as per your requirement
done
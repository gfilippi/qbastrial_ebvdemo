#!/bin/bash

# Default server URL (used if no CLI arg provided)
#SERVER_URL="http://astrial-2g-imx8mp.local/status?format=text"
SERVER_URL="http://10.0.0.3/status?format=text"

# Command to run when script changes
COMMAND="gst-launch-1.0 udpsrc port=5000 caps = \"application/x-rtp-stream, encoding-name=H264\" ! queue ! rtpstreamdepay ! queue ! rtph264depay ! queue ! decodebin ! videoconvert n-threads=8 ! videoscale add-borders=false n-threads=8 ! \"video/x-raw,height=720, width=1280\" !  autovideosink"

# Override with CLI argument if given
if [[ -n "$1" ]]; then
    SERVER_URL="http://$1/status?format=text"
fi

echo $SERVER_URL

last_value=""

while true; do
    current_value=$(curl -s "$SERVER_URL" | tr -d '\r\n')
    #echo $current_value

    if [[ "$current_value" != "$last_value" ]]; then
        if [[ -n "$last_value" ]]; then
            echo "streaming change:"
            echo $current_value

            # Kill any existing gst-launch processes
            while pgrep -x "gst-launch-1.0" > /dev/null; do
                pkill -9 gst-launch-1.0
                sleep 1
            done

            #echo "KILLED!"

            # Only run after the first change
            eval "$COMMAND &"
        fi
        last_value="$current_value"
    fi

    sleep 1
done

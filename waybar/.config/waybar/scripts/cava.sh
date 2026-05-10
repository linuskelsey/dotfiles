#!/bin/bash

# Not my own work. Credit to original author

#----- Optimized bars animation without much CPU usage increase --------
bar="▁▂▃▄▅▆▇█"
dict="s/;//g"

# Calculate the length of the bar outside the loop
bar_length=${#bar}

# Create dictionary to replace char with bar
for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
done

# Create cava config
config_file="/tmp/bar_cava_config_$$"
cat >"$config_file" <<EOF
[general]
# Older systems show significant CPU use with default framerate
# Setting maximum framerate to 30  
# You can increase the value if you wish
framerate = 60
bars = 10

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

while true; do
  if playerctl status 2>/dev/null | grep -q "Playing"; then
    cava -p "$config_file" | sed -u "$dict" &
    CAVA_PID=$!
    # Wait until playback stops
    while playerctl status 2>/dev/null | grep -q "Playing"; do
      sleep 1
    done
    kill $CAVA_PID 2>/dev/null
    echo ""
  fi
  sleep 1
done

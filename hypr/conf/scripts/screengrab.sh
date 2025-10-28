#!/bin/zsh

screenshot_dir="$HOME/Pictures/Screenshots"
filename="$screenshot_dir/$(date +%Y%m%d-%H%M%S).png"

# Create directory if it doesn't exist
mkdir -p "$screenshot_dir"

# Get geometry from slurp
geometry=$(slurp)

# Check if geometry was provided (user didn't cancel)
if [ -z "$geometry" ]; then
	notify-send "Screenshot canceled" "No area selected"
	exit 0
fi

# Take screenshot
if grim -g "$geometry" "$filename"; then
	notify-send "Screenshot saved - Copied to clipboard" "$(basename "$filename")"
else
	notify-send "Screenshot failed" "Could not capture area"
	exit 1
fi

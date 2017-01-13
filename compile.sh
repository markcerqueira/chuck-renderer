#!/bin/sh

# IMPORTANT: Always run this like: $ . ./compile.sh

# Helper file for stopping the current running chuck-renderer container, rebuidling, 
# and starting a new chuck-renderer.

# Stop if needed
docker stop $ID || ('No chuck-renderer is currently running so nothing to stop.')

# Build
docker build -t chuck-renderer .

# Start
# This maps port 9000 of host (your computer) to port 9000 of the image (chuck-renderer)
export ID=$(docker run -p 9000:9000 -d chuck-renderer)

# Print out our container ID to the command-line
echo 'chuck-renderer running with $ID = '$ID

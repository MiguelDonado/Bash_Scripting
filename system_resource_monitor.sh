#!/bin/bash

# Task: Write a script that monitors CPU and memory usage at regular intervals 
# (e.g., every 5 seconds) and logs the information into a file. 
# The script should stop after a specified time or when the user interrupts it.
# Concepts: `top`, `vmstat`, `sleep`, loops, 
# signal handling (e.g., `trap`).

# Specify the log file and the duration in seconds
LOG_FILE="resource_monitor.log"
DURATION=60   # Total time to monitor (in seconds)
INTERVAL=5    # Interval between each check of CPU and memory

# SECONDS is a built-in variable. 
#   a) Automatically initialized to 0 when a script starts.
#   b) Keeps track of the number of seconds that have passed since the script began running.
# $(( ... )) Syntax used for arithmetic expansion
END_TIME=$((SECONDS + DURATION)) # Time when the script should stop monitoring

# Cleanup function to perform actions before exiting
cleanup(){

}
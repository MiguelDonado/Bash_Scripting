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

# This script is capable of handling signals i.e. SIGINT (which is sent when a user presses Ctrl+C, interrupts the script)
# and perform any necessary cleanup actions before terminating. Useful for ensuring that resources are
# properly closed, temporary files are deleted...
# Cleanup function to perform actions before exiting
cleanup(){
    echo -e "\nCleaning up before exiting..."
    echo "Monitoring stopped by user. Check $LOG_FILE for partial results."
    exit
}

# Trap command is used to catch specific signals, such as SIGINT, and runs a command or function
# before the script exits.
# By handling signals, the script can exit gracefully (ends in a controlled manner)
trap cleanup SIGINT

# Create or clear the log file
echo "Timestamp, CPU(%), Memory(%)" > "$LOG_FILE"

echo "Monitoring CPU and memory usage every $INTERVAL seconds for $DURATION seconds"
echo "Logging output to $LOG_FILE"

# Monitoring loop
while [ $SECONDS -lt $END_TIME ]; do
    # Get the current timestamp
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    # Get CPU usage (ignoring the first line header)
    # -b option to operate in a non-interactive mode
    # -n to specify the number of iterations that top will perform before exiting
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

    # Get memory usage
    MEM_USAGE=$(top -bn1 | grep "MiB Mem" | awk '{printf "%.2f", $8 / $4 * 100}')

    # Log the result
    echo "$TIMESTAMP, $CPU_USAGE, $MEM_USAGE" >> "$LOG_FILE"

    # Wait for the specified interval
    sleep "$INTERVAL"
done
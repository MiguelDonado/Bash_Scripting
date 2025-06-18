#!/bin/bash

# 11. Directory Watcher Script
### Task: Create a script that monitors a specific directory for any changes 
### (new, modified, or deleted files). When a change is detected, the script 
### should log the details of the change (file name, type of change, timestamp) 
### to a file.

# Directory to monitor
WATCHED_DIR="/home/miguel/CodingProjects/Bash_Scripting/Miscellaneous/backup"

# Log file to record changes
LOG_FILE="/home/miguel/CodingProjects/Bash_Scripting/Miscellaneous/directory_watcher.log"

# Interval between checks (in seconds)
CHECK_INTERVAL=2

# Initialize associative array file_data to store filenames and their corresponding timestamps
declare -A file_data

# Create or clear log file
> "$LOG_FILE"

# "$WATCHED_DIR"/* works because of globbing expansion. It expands the pattern
# to a list of all files and directories in the WATCHED_DIR directory
# -f file operator checks if the file exists and its a regular file (as opposed to a directory, symlink...)
# Add a key-value pair to the asociative array
# stat command displays info about a file
# -c %Y: Allows me to specify the format of the output. -c allows to specify a custom format,
# and %Y format specifier that outputs seconds since epoch
# Function to capture the current state of files in the directory
capture_initial_state(){
    for file in "$WATCHED_DIR"/*; do
        if [ -f "$file" ]; then
            file_data["$file"]="$(stat -c %Y "$file")"
        fi
    done
}

# Capture initial state
capture_initial_state

echo "Monitoring changes in $WATCHED_DIR ..."
echo "Changes will be logged to $LOG_FILE"
echo "Press [Ctrl+C] to stop monitoring."

# Start monitoring loop
while true; do
    sleep "$CHECK_INTERVAL" # Pause the execution of the script for a specified amount of time

    # Check for current states of files in the directory
    for file in "$WATCHED_DIR"/*;do
        if [ -f "$file" ]; then
            timestamp="$(stat -c %Y "$file")"

            # If I'm trying to access a key on the associative array, and that key doesnt exist
            # the associative array returns me an empty string. Which is considered a falsy value in bash.
            # Check if the file is new
            if [[ ! ${file_data["$file"]} ]]; then
                echo "$(date '+%Y-%m-%d %H:%M:%S') - CREATE - $file" >> "$LOG_FILE"
                echo "Detected change: CREATE-$file"
            elif [[ ${file_data["$file"]} -ne "$timestamp" ]];then
                echo "$(date '+%Y-%m-%d %H:%M:%S') - MODIFY - $file" >> "$LOG_FILE"
                echo "Detected change: Modify - $file"
            fi

            # Create/Update the file's timestamp in the associative array
            file_data["$file"]="$timestamp"
        fi
    done

    # Check for deleted files
    # Explanation of ${!file_data[@]}:
    # - The ! operator when used inside ${}, retrieves the keys of the associative array
    # - [@] indicates that we want all the keys in the array
    # To sum up, that expression gives me back a list that contains all the 
    # files that were saved on the file_data variable
    for file in "${!file_data[@]}";do
        if [ ! -f "$file" ];then
            echo "$date '+%Y-%m-%d %H:%M:%S' - DELETE - $file" >> $LOG_FILE
            echo "Detected change: DELETE -$file"
            # Used to remove a key-value pair from an associative array
            unset file_data["$file"]
        fi
    done
done
#!/bin/bash

### 9. Log File Rotation
#    - Task: Implement a script that simulates log rotation. It should archive a large log 
#      file into a backup folder (with timestamps) when it exceeds a certain size and create a new empty log file.
#    - Concepts: File size check (`stat`), timestamp handling, file archiving, conditionals.

# Configuration
LOG_FILE="/home/miguel/coding-projects/Bash_Scripting/Miscellaneous/test_log_file.log" # Path to the log file
BACKUP_DIR="/home/miguel/coding-projects/Bash_Scripting/Miscellaneous/backup" # Directory to store backups
MAX_SIZE=1048576    # Maximum log file size in bytes


# Create backup directory if it doesn't exist
# The -p gives no error if existing and allows to create any necessary parent directories.
mkdir -p "$BACKUP_DIR"

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
    echo "Log file $LOG_FILE does not exist. Creating a new one."
    touch "$LOG_FILE"
fi

FILENAME=$(basename "$LOG_FILE")


# Get the current size of the log file
# stat command display info about file status (last modification time, created time...)
# The -c option allows us to choose the format of info we want to check about our file
# The %s is the format we are requesting (size in bytes)
FILE_SIZE=$(stat -c%s "$LOG_FILE")

# Check if the file size exceeds the maximum allowed size
if (( FILE_SIZE -gt MAX_SIZE ));then
    # Get current timestamp
    TIMESTAMP=$(date +"%Y%m%d%H%M%S")

    # Archive the log file
    mv "$LOG_FILE" "$BACKUP_DIR/$FILENAME_$TIMESTAMP.log"
    echo "Log file archived to $BACKUP_DIR/$FILENAME_$TIMESTAMP.log"

    # Create a new empty log file
    touch "$LOG_FILE"
    echo "New log file created: $LOG_FILE"
else
    echo "Log file size is within the limit."
fi
#!/bin/bash

# Directory Size Report
# Task: Write a Bash script that monitors the size of a specific directory, 
#       provides a detailed report of each subdirectory's size, and sends an alert 
#       if the total size of the directory exceeds a certain threshold. 
#       Additionally, the script should log the results to a file each time it is run.
# Concepts: Variables, du command, Conditionals, Redirection, Alerts, Looping

#### FUNCTION DEFINITION ####

error(){
    echo $1
    # An exit status of 0 means that the script ended succesfullu
    # An exit status of 1 means that an error has ocurred on the script.
    exit 1
}

#### CHECK USAGE ####

# I put file, because in linux everything is a file (even a directory)
if [[ $# -gt 2 ]];then
    error "Usage: script [file]"
fi

#### VARIABLE DEFINITIONS ####

# Directory to monitor. I use conditional parameter expansion
# DIR variable will hold: 
#   a) First argument passed to the script (if provided)
#   b) If not provided default value. On this case the output of pwd.
# I convert it to absolute path
DIR=$(realpath "${1:-$(pwd)}")

# Log file
LOG_FILE="/home/miguel/coding-projects/Bash_Scripting/Miscellaneous/directory_size_report.log"

# Threshold in bytes (e.g., 1GB = 1000000000)
THRESHOLD=1000000000

# Get current date and time
DATE=$(date '+%Y-%m-%d %H:%M:%S')

#### LOGIC ####
# tee command: Reads from stdin and writes to stdout and files.
#   -a option: Appends the output to the specified file.
if [[ ! -d "$DIR" ]];then
    error "$DATE - ERROR: Directory $DIR does not exist." | tee -a "$LOG_FILE"
fi

# Calculate total size of the directory

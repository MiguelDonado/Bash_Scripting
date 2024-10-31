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
# Check directory exists
# tee command: Reads from stdin and writes to stdout and files.
#   -a option: Appends the output to the specified file.
if [[ ! -d "$DIR" ]];then
    error "$DATE - ERROR: Directory $DIR does not exist." | tee -a "$LOG_FILE"
fi

# Calculate total size of the directory in bytes
# du command: Disk usage command, estimate file space usage of directories and files
# -s: Summarize. Total size of the directory rather than listing the size of each subdirectory and file
# -b: Display the size in bytes
TOTAL_SIZE=$(du -sb "$DIR" | awk '{print $1}')

# Write the report header
echo "===== Directory Size Report for $DIR =====" | tee -a "$LOG_FILE"
echo "Date: $DATE" | tee -a "$LOG_FILE"
# numfmt: Command to reformat numbers
# --to=iec: Option that convert the number to IEC format, which uses 
# binary prefixes (GiB, KiB...) 
echo "Threshold: $(numfmt --to=iec $THRESHOLD)" | tee -a "$LOG_FILE"
echo "------------------------------------------" | tee -a "$LOG_FILE"

# List sizes of each subdirectory in human-readable format
# "$DIR/*" is the syntax used for pathname expansion, it applies the given command
# to each one of the matched expanded items
du -sh "$DIR"/* | tee -a "$LOG_FILE"

# Log the total size in human-readable format
echo "------------------------------------------" | tee -a "$LOG_FILE"
echo "Total size: $(numfmt --to=iec $TOTAL_SIZE)" | tee -a "$LOG_FILE"

# Check if the total size exceeds the threshold
if [[ $TOTAL_SIZE -gt $THRESHOLD ]];then
    echo "WARNING: Directory size exceeds threshold!" | tee -a "$LOG_FILE"
    # Send an alert (can be adjusted based on available mail service)
    # The piped content is gonna be part of the email body
    # mail: Command to send mails
    # -s: Option to specify the subject of your mail
    echo "The directory $DIR has exceeded the size threshold of $(numfmt --to=iec $THRESHOLD)." | mail -s "Directory Size Alert" example@hotmail.es
fi

# Add a line break for readibility in the log file
echo "" | tee -a "$LOG_FILE" 
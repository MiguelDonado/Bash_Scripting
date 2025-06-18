#!/bin/bash

# 25. User Activity Tracker

#     Task: Create a script to track login activity of specific users.
#     Use getopts to specify usernames, time ranges
#     Concepts: User tracking (last, w), getopts, conditionals.

# Default values
USERNAMES=()
START_TIME=""
END_TIME=""
OUTPUT_FORMAT=""

# Usage function
usage(){
    echo "Usage: $0 -u username1,username2 -s start_time -e end_time"
    echo "  -u  Comma-separated list of usernames to track"
    echo "  -s  Start time for filtering login activity (e.g., '2024-01-01')"
    echo "  -e  End time for filtering login activity (e.g., '2024-01-31')"
    exit 0
}

validate_usernames(){
    local usernames=("$@")
    if [ ${#usernames[@]} -eq 0 ];then
        echo "Error: At least one username must be specified."
        exit 1
    fi
}

validate_date(){
    local date="$1"
    if ! [[ "$date" =~ ^20[0-9]{2}-(0[1-9]|1[0-2])-([0-2][1-9]|3[01])$ ]]; then
        echo "Error: The provided date $1 is not on the right format YYYY-MM-DD"
        exit 1
    fi
}

# Function to fetch login activity
fetch_activity() {
    local user="$1"
    local start="$2"
    local end="$3"
    last "$user" --since "$start" --until "$end"
}

# Parse options
OPTSTRING=":u:s:e:h"

while getopts "$OPTSTRING" opt; do
    case "$opt" in
        u)
            # There is no neet to set IFS to his original state,
            # because when i set IFS within a block or a command, 
            # it only affects that block or command
            IFS=','
            read -r -a USERNAMES <<< "$OPTARG"
            validate_usernames "${USERNAMES[@]}"
            ;;
        s)
            START_TIME="$OPTARG"
            validate_date "$START_TIME"
            ;;
        e)
            END_TIME="$OPTARG"
            validate_date "$END_TIME"
            ;;
        h)
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument. Execute $0 -h to display help."
            exit 1
            ;;
        ?)
            echo "Invalid option: -$OPTARG."
            exit 1
            ;;
    esac
done

# Collect data
output_data=""
for user in "${USERNAMES[@]}"; do
    activity=$(fetch_activity "$user" "$START_TIME" "$END_TIME")
    if [ -z "$activity" ]; then
        activity="No activity found for user $user"
    fi

    output_data+="\nUser: $user\n$activity\n"
done

# Output data
echo -e "$output_data"


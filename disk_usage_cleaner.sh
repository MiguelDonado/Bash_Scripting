#!/bin/bash

# 19. Disk Usage Cleaner
#     Task: Create a script that identifies files or directories over a specified size within a 
#     given directory and offers the user options to delete them. Add an option to automatically 
#     delete files older than a specified number of days.
#     Concepts: Disk usage (du), file size and age (find, stat), user input, file manipulation.

# Function to display a header
print_header(){
    echo "=== Disk Usage Cleaner ==="
    echo ""
}

# Default values
dir="."
size=""
days=""

# Parse command-line options using getopts
OPTSTRING=":d:s:t:h"

while getopts "$OPTSTRING" opt; do
    case $opt in
        d)
            dir="$OPTARG"
            # Check if directory exists
            if [ ! -d "$dir" ]; then
                echo "Invalid directory specified: $dir"
                exit 1
            fi 
            ;;
        s)
            size="$OPTARG"
            ;;
        t)
            days="$OPTARG"
            # Check if days is numeric
            if ! [[ "$days" =~^[0-9]+$ ]]; then
                echo "Option -t expects a numeric value. Argument ${OPTARG} is invalid."
                exit 1
            fi
            ;;
        h)
            echo "Usage: $0 [-d directory] [-s size] [-t days] [-h help]"
            echo "  -d: Directory to scan (default is current directory)"
            echo "  -s: Minimun file size to search for (e.g., 100M, 1G)"
            echo "  -t: Delete files older than specified days"
            echo "  -h: Display help"
            exit 0
            ;;
        :)
            echo "Option -${OPTARG} requires an argument."
            exit 1
            ;;
        ?)
            echo "Invalid option: -${OPTARG}."
            exit 1
            ;;
    esac
done

# Check if directory exists
if [ ! -d "$dir" ]; then
    echo "Invalid directory specified: $dir"
    exit 1
fi

# Main function
main() {
    print_header
    echo "Searching for files larger than $size in $dir..."
    echo ""

    # Find files or directories larger than specified size
}




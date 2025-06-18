#!/bin/bash

# 23. File Search Tool

#     Task: Develop a script to search for files based on name,
#     extension, or size. Use getopts to specify search criteria 
#     and options for recursive search or displaying detailed output.
#     Concepts: File searching (find), getopts, conditionals.

# Function to display usage
usage() {
    echo "Usage: $0 [-n name] [-e extension] [-s size] [-r] [-d] [-h] directory"
    echo "Options:"
    echo "  -n name         Search for files with this name (can include wildcards)"
    echo "  -e extension    Search for files with this extension"
    echo "  -s size         Search for files of this size (e.g., +1M, -100k)"
    echo "  -r              Enable recursive search"
    echo "  -d              Display detailed output"
    echi "  -h              Display help"
    echo "  directory       Directory to search in"
    exit 0
}

# Initialize variables
name=""
extension=""
size=""
recursive=false
detailed=false

# Parse options
OPTSTRING=":n:e:s:rdh"
while getopts "$OPTSTRING" opt; do
    case $opt in
        n)
            name="$OPTARG"
            ;;
        e)
            extension="$OPTARG"
            ;;
        s)
            size="$OPTARG"
            ;;
        r)
            recursive=true
            ;;
        d)
            detailed=true
            ;;
        h)
            usage
            ;;
        :)
            echo "Option -${OPTARG} requires an argument."
            ;;
        ?)
            echo "Invalid option: -${OPTARG}."
            exit 1
            ;;
    esac
done

# Shift positional arguments in as shell script
# Shift command used to shift the positional parameters to the left
# OPTIND: variable used by getopts to track the index of the next argument to be processed
# OPTIND - 1: Number of arguments to shift. Removes all options that have been processed by getopts from the positional parameters
# After processing options with getopts, the script uses shift $((OPTIND - 1)) to remove the processed options from the positional parameters.
# This allows the script to access the remaining arguments (e.g., the directory) directly using $1, $2,
shift $((OPTIND - 1))

# Check for required directory argument
if [ $# -ne 1 ]; then
    usage
fi

directory="$1"
full_filename="$name*.$extension"

# Build the find command 
find_command="find $1"

if [ "$recursive" == false ]; then
    find_command+=" -maxdepth 1"
fi

if [ "$name" != "" ];then
    find_command+=" -name $name"
fi

if [ "$size" != "" ]; then
    find_command+=" -size $size"
fi

if [ "$detailed" == true ]; then
    find_command+=" -exec ls -lh {} +"
fi

# Evaluate the command
eval $find_command

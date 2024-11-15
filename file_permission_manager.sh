#!/bin/bash

# 21. File Permission Manager

#     Task: Create a script that modifies file permissions based on user-specified 
#     options. 
#     Use getopts to allow users to set read, write, or execute permissions for 
#     files or directories.
#     Concepts: File permissions (chmod), getopts, conditionals.

# Function to display usage information
usage() {
    echo "Usage: $(basename "$0") -f <file_directory> -u <user/group/others> -p <permissions> [-r]"
    echo ""
    echo "Options:"
    echo "  -f <file_or_directory>  Specify the target file or directory."
    echo "  -u <user/group/others>  Specify 'u' (user), 'g' (group), or 'o' (others)."
    echo "  -p <permissions>        Specify permissions as 'r', 'w', 'x', or a combination (e.g., 'rw')."
    echo "  -r                      Apply permissions recursively (for directories only)."
    exit 0
}

# Function to validate permisions
validate_permissions() {
    if ! [[ "$1" =~ ^[rwx]+$ ]]; then
        echo "Error: Invalid permission string $1. Execute command with -h option to display help."
        exit 1
    fi
}

# Function to validate user/group/others
validate_target() {
    if ! [[ "$1" =~ ^[ugo]$ ]]; then
        echo "Error: Invalid target '$1'. Execute command with -h option to display help."
    fi
}

# Function to check if the file/directory provided exists
check_file() {
    if ! [[ -e "$file" ]]; then
        echo "Error: File or directory '$file' does not exist."
        exit 1
    fi
}

# Initialize variables
file=""
target=""
permissions=""
recursive=""

OPTSTRING=":f:u:p:r:h"

# Parse options
while getopts "$OPTSRING" opt; do
    case "$opt" in
        f)
            file="$OPTARG"
            check_file "$file"
            ;;
        u)
            target="$OPTARG"
            validate_target "$target"          
            ;;
        p)
            permissions="$OPTARG"
            validate_permissions "$permissions"
            ;;
        r)
            recursive=True
            ;;
        h)
            usage
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

main() {
    chmod "$target+$permissions" "$file" ${recursive:+"-R"} \
    && echo "Permissions '$permissions' successfully applied to '$file' for '$target'" \
    || { echo "Error: Failed to apply permissions."; exit 1; }
}

main


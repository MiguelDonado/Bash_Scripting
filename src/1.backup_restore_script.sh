#!/bin/bash

# Backup a directory 
    # Source: (the current directory by default)

# Create a script that backs up a specified directory (with all its contents) into a compressed .tar.gz archive. 


DEFAULT_SOURCE=${1:-$(pwd)} # Practicing conditional parameters expansion modifiers
DEFAULT_DESTINY="/home/miguel/Backup"
# Initialize variables that will hold the target source and destiny folders.
# Will be populated with a value, based on the arguments provided by the user on the CLI when calling this command
target_source=""
target_destiny=""

############ FUNCTIONS ###########
error(){
    echo "$1"
    exit 1
}

check_exists(){
    local fullpath="$1"
    if [[ ! -d "$fullpath" && ! -f "$fullpath" ]];then
        error "The provided path does not exist: $fullpath"
    fi
}

##################################

# Check arguments provided by the user via CLI
if [[ $# -gt 1 ]];then
    error "Usage: script [SOURCE]"
elif [[ $# == 1 ]];then
    target_source=$(realpath "$1")
    check_exists $target_source
elif [[ $# == 0 ]];then
    target_source="$DEFAULT_SOURCE"
fi

target_destiny="$DEFAULT_DESTINY"

########### BEGINNING OF PROGRAM EXECUTION ######################

# Get current date and time
current_date_time=$(date +"%Y%m%d_%H%M%S")

# Construct the filename
source_name=$(basename $target_source)
filename_tar_gz="${source_name}_${current_date_time}.tar.gz"
fullpath_tar_gz="$target_destiny/$filename_tar_gz"

# Create a tar.gz archive
# The solution involves using -C option to change directory to the root (/),
# then specifying the file tree to archive without a leading slash,
# because now you only need a relative path. This does the same thing as a normal
# tar create command, but no stripping is needed:
tar -czf "$fullpath_tar_gz" -C / "${target_source#/}"
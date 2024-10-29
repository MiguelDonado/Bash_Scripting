#!/bin/bash

# This script has been created to facilitate developing and debugging of the scrapingFincasHacienda project. 
# Goals
#   1. Clean 'logs' folder
#   2. Clean each subfolder inside 'data' folder
#   3. Remove FincasProject.db file.

# ABSOLUTE PATHS SINCE THE PROJECT WONT CHANGE LOCATION
DATAPATH="/home/miguel/coding-projects/ScrapingFincasHacienda/data"
LOGSPATH="/home/miguel/coding-projects/ScrapingFincasHacienda/scrapingFincasHacienda/logs"
DBPATH="/home/miguel/coding-projects/ScrapingFincasHacienda/scrapingFincasHacienda/FincasProject.db"

# Given a directory, it empty each subfolder.
folder_remove(){
    # Check an argument is provided when the function is called
    if [[ $# != 1 ]];then
        return 1
    fi
    # Check directory provided as argument exists
    if [ -d "$1" ]; then
        # Check if directory is empty
        if [ -z "$(ls -A "$1")" ]; then
            echo "The directory $1 is empty."
        # If is not empty
        else
            # Iterate through each file on the directory
            for file in "$1"/*; do
                # Remove file
                rm "$file"
                echo "The file $file has been removed."
            done
        fi
    # If directory provided as argument not exists
    else
        echo "The directory $1 does not exist."
    fi
}

###### DATABASE ######

# If database file exists, then remove it.
if [ -f "$DBPATH" ]; then
    rm "$DBPATH"
    echo "The database $DBPATH has been removed."
fi

###### LOGS #######

# Empty logs folder
folder_remove "$LOGSPATH"

###### DATA #######

# List subfolders in '/data' folder and stored them in an array
subfolders=$(ls "$DATAPATH")

# If there're subfolders inside 'Data' folder
if [[ -n "$subfolders" ]]; then
    # Empty each '/data/subfolder'
    for subfolder in $subfolders; do
        # Get full path of subfolder
        fullpath_subfolder="$DATAPATH/$subfolder"
        # Empty subfolder
        folder_remove "$fullpath_subfolder"
    done
fi
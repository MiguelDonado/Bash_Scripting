#!/bin/bash

# This script has been created to facilitate developing and debugging of the scrapingFincasHacienda project. 
# Mainly to clean the logs folder, and each subfolder inside data folder as well as to remove the FincasProject.db.

DATAPATH="/home/miguel/coding-projects/ScrapingFincasHacienda/data"
LOGSPATH="/home/miguel/coding-projects/ScrapingFincasHacienda/scrapingFincasHacienda/logs"
DBPATH="/home/miguel/coding-projects/ScrapingFincasHacienda/scrapingFincasHacienda/FincasProject.db"

folder_remove(){
    if [ -d "$1" ]; then
        if [ -z "$(ls -A "$1")" ]; then
            echo "The directory $1 is empty."
        else
            for file in "$1"/*; do
                rm "$file"
                echo "The file $file has been removed."
            done
        fi
    else
        echo "The directory $1 does not exist."
    fi
}

# If database file exists, then remove it.
if [ -f "$DBPATH" ]; then
    rm "$DBPATH"
    echo "The database $DBPATH has been removed."
fi

# Empty logs folder
folder_remove "$LOGSPATH"

# List subfolders in '/data' folder
subfolders=$(ls "$DATAPATH")

# Empty each '/data/subfolder' inside '/data' folder
for subfolder in $subfolders; do
    # Get full path of the subfolders
    fullpath_subfolder="$DATAPATH/$subfolder"

    # Empty subfolder
    folder_remove "$fullpath_subfolder"
done
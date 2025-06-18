#!/bin/bash

# Organize files (in the current directory by default)
: '
1. File Organizer Script

    Task: Write a script that organizes files in a directory by their extensions. 
    For example, all .txt files go into a TextFiles folder, .jpg into Images, and so on. 
    The script should handle files with no extensions as well.
    Concepts: File manipulation, loops, string manipulation, conditionals.
'

# Print the error message and exit the script
error(){
    echo "$1"
    exit 1  # Exit status code, indicates an error 
}

# Check usage script
if [ $# == 1 ];then
    # If a target directory is passed as an argument check if not exists
    if [ ! -d "$1" ];then
        error "The specified directory '$1' doesn't exists on the actual path '$(pwd)'"
    # If the target directory exists store it on a variable
    else
        target_directory="$(pwd)/$1"
    fi
# If no arguments are provided, set the target_directory to be the current directory
elif [ $# == 0 ];then
    target_directory="$(pwd)"
else
    error "Usage: script [FILE]"
fi

# Declare an associative array (dictionary-like structure)
declare -A file_categories

# Populate the associate array
file_categories=(
    ["txt"]="TextFiles"
    ["jpg"]="Images"
    ["png"]="Images"
    ["py"]="Programming"
    ["r"]="Programming"
    ["sh"]="Programming"
    ["sql"]="Programming"
    ["pdf"]="PDFs"
    ["db"]="Databases"
)

# Arguments:
#   1) Category
create_dir(){
    local categorize_folder="$target_directory/$1"
    # If the directory doesnt exists
    if [ ! -d "$categorize_folder" ];then
        mkdir "$categorize_folder"
    fi
}


# Move a file to a destiny folder.
#    1) Check if exists a file with the same name on the destiny folder
#        a) If so, prompt the user asking if he wants to overwrite
# ----------------------------
# It receives 2 parameters:
#     1º current_filename
#     2º destiny folder

move_file(){
    local fullpath="$1"
    local categorize_folder="$target_directory/$2"
    local filename=$(basename $(realpath $fullpath))

    if [ -f "$categorize_folder/$filename" ];then
        echo "The file '$filename' you want to move already exists on the destiny folder '$categorize_folder'" | tr -s /
        echo -n "Overwrite? [s/n]: "
        read resultado
        if [[ $resultado == [sS] ]];then
            echo "The file '$filename' has been overwritten on '$categorize_folder' folder."
            mv $fullpath "$categorize_folder/$filename"
        else
            extension="${fullpath##*.}"
            new_filename="${original_filename%.*}-copy.${extension}" 
            mv "$fullpath" "$categorize_folder/$new_filename"
        fi
    else
        mv "$fullpath" "$categorize_folder/$filename"  
    fi
}

# Function to categorize file
categorize_file(){
    local fullpath="$1"
    local extension=$(echo ${fullpath##*.} | tr '[:upper:]' '[:lower:]') # Normalizes file extension to lowercase 
    local category="${file_categories[$extension]}"

    category=${category:-"Uncategorized"}
    create_dir $category 
    move_file "$fullpath" "$category" || error "Failed to move $fullpath to $category"
}



####################### BEGINNING OF EXECUTION ######################

# List all files on the actual directory (including hidden files) (just returns the relative path)
files=$(exa -fa "$target_directory")

for file in $files;do
    # Get full path of the file
    fullpath=$(echo "$target_directory/$file" | tr -s '/') 
    # If the file is this script, continue
    if [[ "$fullpath" == "$0" ]]; then
        continue
    else
        categorize_file "$fullpath"
    fi
done

echo "File organization complete."


#!/bin/bash

### 8. **User Account Manager**
###   - Task: Create a script that can add, delete, or modify user accounts on a system. The script should also check if a user already exists before adding them and allow for batch processing from a file.
###   - Concepts: User management (`useradd`, `usermod`, `userdel`), conditionals, file parsing, error handling.

# Function to check if a user exists. Components:
# 1. id command is used to get user information
# 2. &>: Is the operator used to redirect both stdout and stderror
# 3. /dev/null: Is a special file in Linux, that discards all data written to it.
user_exists(){
    id "$1" &>/dev/null
}

# Function to add a user. Components:
# 1. useradd command is used to add a user
# 2. && is like shortcircuit syntax in JS
add_user(){
    if user_exists "$1"; then
        echo "User '$1' already exists. Skipping..."
    else
        sudo useradd "$1" && echo "User '$1' added."
    fi
}

# Function to delete a user. Components:
# 1. userdel command is used to delete a user
delete_user(){
    if user_exists "$1";then
        sudo userdel "$1" && echo "User '$1' deleted."
    else
        echo "User '$1' does not exist. Skipping..."
    fi
}

# Function to modify a user (e.g., change the user's home directory). Components
# 1. usermod command is used to modify a user
# 2. $1 = username, $2 = options
modify_user(){
    if user_exists "$1"; then
        sudo usermod "$2" "$1" && echo "User '$1' modified with option: $2."
    else
        echo "User '$1' does not exist. Skipping..."
    fi
}



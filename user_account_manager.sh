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

# Function to process a batch file
process_file() {
    # The keyword local is used to set explicitly the scope of the variable local to this function
    # In most programmig languages, variables declared inside a function are automatically local to that function.
    # In Bash, you need to do it explicitly.
    local file="$1" 
    # IFS stands for internal field separator. It determines how Bash recognizes word boundaries while splitting 
    # a sequence of characters strings. By default it uses spaces, tabs or newlines.
    # I set the IFS within the while, because it ensures that it only affects the following command (on this case the read command)
    # inside the loop. It's a common practice to avoid unintended effects on other parts of the script.
    # The read command, reads from stdin line by line, and stores the results in 3 variables
    # The loop exits when the read command returns a non-zero exit status, which happens when there
    # are no more lines to read
    # The -r option of the read command is used so that characters are interpreted as literal characters.
    # I redirect the stdin to the read command at the end of the loop, on the bottom
    while IFS=, read -r action username options; do
        case "$action" in
            add)
                add_user "$username"
                ;;
            delete)
                delete_user "$username"
                ;;
            modify)
                modify_user "$username" "$options"
                ;;
            *)
                echo "Invalid action '$action' for user '$username'. Skipping..."
                ;;
        esac
    done < "$file"
}            

# Script usage
usage() {
    echo "Usage: $0 {add|delete|modify|batch} [username] [options|file]"
    exit 1
}

# Logic

case "$1" in
    add)
        [[ -z "$2" ]] && usage
        add_user "$2"
        ;;
    delete)
        [[ -z "$2" ]] && usage
        delete_user "$2"
        ;;
    modify)
        [[ -z "$2" || -z "$3" ]] && usage
        modify_user "$2" "$3"
        ;;
    batch)
        [[ -z "$2" ]] && usage
        process_file "$2" 
        ;;
    *)
        usage
        ;;
esac




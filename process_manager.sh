#!/bin/bash
### 5. Process Manager
###   Task: Create a script that takes a process name or PID as 
###   input and offers options to terminate, 
###   restart, or change the priority (nice value) of the process.

##### Clarifications #####

# 1.
# pgrep is a command used to find the id of a process given is name
# What does the -f option:
# pgrep python (this looks for processes that have exactly the name python)
# But if i started a script like: python /home/user/scripts/my_script.py
# The actual command running is python, and my_script.py is just an argument to python.
# If you try to find this process using pgrep my_script.py, it won’t work because pgrep only looks for the process name, not the whole command.
# Using pgrep -f tells pgrep to look at the entire command line
# With -f, pgrep will search for any process where the whole command (in this case, python /home/user/scripts/my_script.py) contains "my_script.py".

########################################################

error(){
    echo "$1"
    exit 1
}

# Function to find pid from process name
get_pid_from_name(){
    pid=$(pgrep -f "$1")
# -z is a string comparison operator and its true if the length of the string is zero
    if [[ -z "$pid" ]]; then
        error "Process \"$1\" not found."
    fi
    echo "$pid"
}

# Check the user is proving one argument. 
# Anything else should raise an error
if [[ $# != 1 ]];then
    error "Usage: script pid|name"
fi

# Check if input is pid or process name
# =~ performs a regular expression match
if [[ "$1" =~ ^[0-9]+$ ]]; then
    pid=$1
else
    pid=$(get_pid_from_name "$1")
fi

# Display options to the user
echo "Process Manager for PID $pid"
echo "Select an action:"
echo "1. Terminate the process"
echo "2. Restart the process"
echo "3. Change the process priority (nice value)"
# The option p is used to display a prompt to the user
# before reading the input
# It's gonna store the input value on the variable choice
read -p "Enter choice [1-3]: " choice

case $choice in 
    1) 
        # Terminate the process, shortcircuit operators like in js
        kill "$pid" && echo "Process $pid terminated." || error "Failed to terminate process $pid."
        ;;
    2)
        # Restart the process
        # ps is a command used to display info about active processes
        # The -p option is used to specify the process ID for which information is to be displayed
        # The -o command specifies the output format. comm stands for command name, and the '=' is to
        # ensure that the output does not include the header line.
        process_name=$(ps -p "$pid" -o comm=)
        kill "$pid" && echo "Process $pid terminated. Restarting..." || error "Failed to restart process $pid"
        sleep 1 # brief pause to ensure termination
        # The $! variable holds the PID of the most recent executed background process
        # The ampersand is used to start the process in the background.
        # Because the first process is intended to run in the background we can 
        # place a command after on the same line.
        $process_name & echo "Process restarted with new PID $!"
        ;;
    3) 
        # Change the process priority
        read -p "Enter new nice value (-20 to 19): " new_nice
        # Nice value must be between -20 and 19. Being -20 the highest priority and 19 the lowest.
        if [[ "$new_nice" =~ ^-?[0-9]+$ ]] && ((new_nice >= -20 && new_nice <=19));then
            renice "$new_nice" -p "$pid" && echo "Priority of process $pid changed to $new_nice." || error "Failed to change priority."
        else
            error "Invalid nice value. Must be between -20 and 19."
        fi
        ;;
    *)
        error "Invalid choice."
        ;;
esac
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

# Things to consider: How to do when given a name, and it returns several pid

error(){
    echo "$1"
    exit 1
}

# Function to find pid from process name
get_pid_from_name(){
    pid=$(pgrep -f "$1")
# -z is a string comparison operator and its true if the length is zero
    if [[ -z "$pid" ]]; then
        echo "Process \"$1\" not found."
        exit 1
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
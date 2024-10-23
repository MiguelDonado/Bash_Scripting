#!/bin/bash

# Todo List Manager
# - Task: Build a simple command-line Todo list manager 
#         with options to add, view, delete, and mark tasks as completed. 
#         Store the tasks in a text file.
# - Concepts: File reading/writing, string manipulation, user input, 
#             conditionals.

# File to store tasks
TODO_FILE="$HOME/coding-projects/Bash_Scripting/todo.txt"

#Check if it exists the todo file


error(){
    echo "$1"
    exit 1
}

# Check usage of command is right
if [[ $# != 0 ]];then
    error "Usage: script [no arguments]"
fi

# Function to display the menu
display_menu(){
    echo "---------- To-Do List Manager ----------"
    echo "1) Add task"
    echo "2) View task"
    echo "3) Delete task"
    echo "4) Mark task as done"
    echo "5) Exit" 
}

add_task(){
    read -p "Enter the task: " task
    echo "$task" >> "$TODO_FILE"
    echo "Task added"
}

view_tasks(){
    if [ ! -f $TODO_FILE ] || [ ! -s $TODO_FILE ];then
        echo "No task available"
    else
        echo "" # To add a new line
        echo "----- To-Do List -----"
        cat -n "$TODO_FILE"
        echo "" # To add a new line
    fi
}

mark_done(){
    view_tasks
    read -p "Enter the task number to delete: " task_number
    
    # Check the exit status of the sed command
    # Returns 0 if successfully
    # Every command has an exit status code:
    #   0: If successful (truthy)
    #   Non-zero indicates an encounter an error (falsy)
    if sed -i "${task_number}s/^/[DONE] /" "$TODO_FILE"; then
        echo "Task marked as done!"
    else
        echo "Invalid task number!"
    fi
}

delete_task(){
    view_tasks
    read -p "Enter the task number to delete: " task_number
    if sed -i "${task_number}d" "$TODO_FILE"; then
        echo "Task deleted!"
    else
        echo "Invalid task number!"
    fi
}


# Main program loop
while true; do
    display_menu
    read -p "Choose an option: " choice
    case $choice in
        1)
          add_task 
          ;;
        2) 
          view_tasks
          ;;
        3) 
          delete_task 
          ;;
        4)
          mark_done 
          ;;
        5)
          echo "Exiting..." 
          break 
          ;;  
        *)
          echo "Invalid option, please try again!" 
          ;;
    esac
done
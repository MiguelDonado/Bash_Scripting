#!/bin/bash

# 24. Custom Command-Line Calculator

#     Task: Develop a simple calculator script that supports addition, 
#     subtraction, multiplication, and division. Use getopts to specify 
#     numbers and the operation.
#     Concepts: Arithmetic operations, getopts, user input validation.

# Function to display usage
usage() {
    echo "Usage: '$(basename $0)' -a <number1> -b <number2> -o <operation>"
    echo "Operations:"
    echo "  add         Addition"
    echo "  sub         Subtraction"
    echo "  mul         Multiplication"
    echo "  div         Division"
    exit 0
}

# Validate inputs. 
# Simple regex to match numbers that used "." as decimal separator. Expects nothing for thousands separator.
validate_number() {
    if ! [[ "$1" =~ ^-?[0-9]+(\.[0-9]+)?$ ]];then
        echo "Error: $1 is not a valid number."
        exit 1
    fi
}   

# Initialize variables
num1=""
num2=""
operation=""

OPTSTRING=":a:b:o:h"

# Getopts
while getopts "$OPTSTRING" opt; do
    case "$opt" in
        a)
            num1="$OPTARG"
            validate_number "$num1"
            ;;
        b)
            num2="$OPTARG"
            validate_number "$num2"
            ;;
        o)
            operation="$OPTARG"
            ;;
        h)
            usage
            ;;
        :) 
            echo "Option -${OPTARG} requires an argument."
            ;;
        ?)
            echo "Invalid option: -${OPTARG}."
            ;;
    esac
done

# Perform operation
main() {
    case "$operation" in
        add)
            result=$(echo "$num1 + $num2" | bc -l)
            ;;
        sub)
            result=$(echo "$num1 - $num2" | bc -l)
            ;;
        mul)
            result=$(echo "$num1 * $num2" | bc -l)
            ;;
        div)
            if [[ "$num2" == "0" ]]; then
                echo "Error: Division by zero is not allowed."
                exit 1
            fi
            result=$(echo "$num1 / $num2" | bc -l)
            ;;
        *)
            echo "Error: Invalid operation '$operation'."
            exit 1
            ;;
    esac

# Display the result
echo "Result: $result"
}

main





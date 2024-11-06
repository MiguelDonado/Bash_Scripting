#!/bin/bash

# 16. Password Generator
#     Task: Write a script that generates a random, secure password based on given length 
#     and complexity options (e.g., uppercase, lowercase, numbers, special characters).
#     Concepts: Randomization, string manipulation, user input, conditional arguments.

generate_password(){
    local length=$1
    local include_upper=$2
    local include_lower=$3
    local include_numbers=$4
    local include_special=$5

    # Define characters sets
    local upper_chars="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local lower_chars="abcdefghijklmnopqrstuvwxyz"
    local numbers="0123456789"
    local special_chars="!@#$%^&*()-_=+[]{}|;:,.<>?"

    # Start with an empty character set
    local char_set=""

    # Append selected characters based on user's choice
    if [[ $include_upper == "yes" ]];then
        char_set+=$upper_chars
    fi
    if [[ $include_lower == "yes" ]];then
        char_set+=$lower_chars
    fi
    if [[ $include_numbers == "yes" ]];then
        char_set+=$numbers
    fi
    if [[ $include_special == "yes" ]];then
        char_set+=$special_chars
    fi

    # Check if at least one character is selected
    if [[ -z $char_set ]];then
        echo "You must select at least one type of character (uppercase, lowercase, numbers, special characters)."
        exit 1
    fi

    # Generate the password of the specified length using the selected character set
    # -d option to delete
    # -c option to use the complement of ARRAY1
    # /dev/urandom is a file that provides random data
    password=$(tr -dc $char_set </dev/urandom | head -c $lenght)
    echo "$password"
}

# Ask user for password length and complexity preferences
echo "Password length:"
read length

echo "Uppercase letters? (yes/no):"
read include_upper

echo "Lowercase letters? (yes/no):"
read include_lower

echo "Numbers? (yes/no):"
read include_numbers

echo "Special characters? (yes/no):"
read include_special

# Generate and display the password
generate_password $length $include_upper $include_lower $include_numbers $include_special

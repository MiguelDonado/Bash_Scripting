#!/bin/bash

# Script made to practice skills with getopts built in tool

OPTSTRING=":x:y:"

while getopts "$OPTSTRING" opt; do
    
    case $opt in

        x)
            echo "Option -x was triggered. Argument ${OPTARG} was provided."
            ;;
        y)
            echo "Option -y was triggered. Argument ${OPTARG} was provided."
            ;;
        :)
            echo "Option -${OPTARG} requires an argument."
            exit 1
            ;;
        ?)
            echo "Invalid option: -${OPTARG}"
            exit 1
            ;;
    esac
done
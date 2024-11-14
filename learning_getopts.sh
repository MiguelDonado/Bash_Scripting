#!/bin/bash
# This script was created to practice getopts built in tool

OPTSTRING=":ab"

while getopts "$OPTSTRING" opt; do
    case "$opt" in
        a)
            echo "Option -a was triggered"
            ;;
        b)
            echo "Option -b was trigerred"
            ;;
        ?)
            echo "Invalid option: -"$OPTARG"."
            exit 1
            ;;
    esac
done

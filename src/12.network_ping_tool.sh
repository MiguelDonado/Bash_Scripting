#!/bin/bash

# 22. Network Ping Tool

#     Task: Write a script to ping multiple IP addresses or domain names specified as arguments. 
#     Use getopts to set the number of ping attempts and timeout duration.
#     Concepts: Networking (ping), getopts, loops, string parsing.

# Function to display usage
usage(){
    echo "Usage: $0 [-a attempts] [-t timeout] host1 host2 ... hostN"
    echo " -a attempts      Number of ping attempts (default: 4)"
    echo " -t timeout       Timeout duration in seconds (default: 1)"
    echo " -h help          Display usage"
    exit 0
}

# Parse options
OPTSTRING=":a:t:h"
while getopts "$OPTSTRING" opt; do
    case $opt in
        a)
            attempts="$OPTARG"
            ;;
        t)
            timeout="$OPTARG"
            ;;
        h)
            usage
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

# Removed parsed options from positional parameters
shift $((OPTIND - 1))

# Check if at least one host is provided
if [ "$#" -lt 1 ]; then
    usage
    exit 1
fi

# Ping each host
for host in "$@"; do
    echo -e "Pinging $host with $attempts attempts and $timeout-seconds timeout:\n"
    ping -c "$attempts" -W "$timeout" "$host" && echo -e "\nPing successful" || echo -e "\nPing failed"
    echo
done
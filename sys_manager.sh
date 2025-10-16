#!/bin/bash

add_users() {
    usernames_file="$1"
    if [ -z "$usernames_file" ]; then
        echo "Usage: ./sys_manager.sh add_users <usernames_file>"
        exit 1
    fi

    if [ ! -f "$usernames_file" ]; then
        echo "File '$usernames_file' not found!"
        exit 1
    fi

    created=0
    exists=0
    while read -r username; do
        if [ -z "$username" ]; then continue; fi
        if id "$username" &>/dev/null; then
            echo "User '$username' already exists."
            ((exists++))
        else
            useradd -m "$username"
            if [ $? -eq 0 ]; then
                echo "User '$username' created successfully."
                ((created++))
            else
                echo "Failed to create user '$username'."
            fi
        fi
    done < "$usernames_file"

    echo
    echo "Summary: Users created: $created, Already existed: $exists"
}

if [ "$1" == "add_users" ]; then
    add_users "$2"
else
    echo "Invalid mode! Use: ./sys_manager.sh add_users <usernames_file>"
    exit 1
fi
#system report#

if [ "$1" == "sys_report" ]; then
    if [ -z "$2" ]; then
        echo "Usage: ./sys_manager.sh sys_report <output_file>"
        exit 1
    fi

    output_file="$2"

    {
        echo "===== System Report ====="
        echo "Date: $(date)"
        echo
        echo "Disk Usage:"
        df -h
        echo
        echo "Memory Info:"
        free -h
        echo
        echo "CPU Info:"
        lscpu | grep 'Model name\|CPU(s)\|Thread\|Core'
        echo
        echo "Top 5 Memory-Consuming Processes:"
        ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6
        echo
        echo "Top 5 CPU-Consuming Processes:"
        ps -eo pid,comm,%mem,%cpu --sort=-%cpu | head -n 6
    } > "$output_file"

    echo "System report saved to $output_file"

else
    echo "Invalid mode! Use: ./sys_manager.sh sys_report <output_file>"
    exit 1
fi

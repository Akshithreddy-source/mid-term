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

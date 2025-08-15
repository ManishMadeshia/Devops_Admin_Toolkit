#!/bin/bash

LOGFILE="/var/log/user_management.log"

add_user(){
    read -p "enter a username to add:" username
    if id "$username" &>/dev/null; then
        echo "user $username already exists." | tee -a $LOGFILE
    else
        useradd "$username"
        echo "User $username added successfully." | tee -a $LOGFILE
    fi
}

delete_user(){
    read -p "Enter a username to delete:" username
    if id "$username" &>/dev/null; then
        userdel "$username"
        echo "User $username deleted successfully." | tee -a $LOGFILE
    else
        echo "User $username does not exist." | tee -a $LOGFILE
    fi
}

list_user(){
    echo "List of users:" | tee -a $LOGFILE
    cut -d: -f1 /etc/passwd | tee -a $LOGFILE
}

set_passwd(){
    read -p "Enter Username to set Password:" username
    if id "$username" &>/dev/null; then
        passwd "$username"
        echo "User $username password change succesfully" | tee -a $LOGFILE
    else
        echo "Username $username does not exist" | tee -a $LOGFILE
        echo "Choose option 1 to create New User Then change password"
    fi 
}

while true; do
    echo "User Management Menu:"
    echo "1. Add user"
    echo "2. Delete User"
    echo "3. List User"
    echo "4. Set Password"
    echo "5. Exit"
    read -p "Choose an option:" option

case $option in 
    1) add_user ;;
    2) delete_user ;;
    3) list_user ;;
    4) set_passwd ;;
    5) echo "Existing..." ; exit 0 ;;
    *) echo "Invalid Option, Please try again." ;;
    esac
done

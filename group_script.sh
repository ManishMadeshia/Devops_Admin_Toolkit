#!/bin/bash

LOGFILE="/var/log/group_management.log"

#function to add a group
add_group(){
    read -p "Enter group name to add:" groupname
    if getent group "$groupname" &>/dev/null; then
        echo "Group $groupname already exists." | tee -a "$LOGFILE"
    else
        groupadd "$groupname"
        echo "Group $groupname added successfully." | tee -a "$LOGFILE"
    fi
}

# function to delete group
delete_group(){
    read -p "Enter group name to delete: " groupname
    if getent group "$groupname" &>/dev/null; then
        groupdel "$groupname"
        echo "Group $groupname deleted sucessfully." | tee -a "$LOGFILE"
        else
            echo "Group $groupname does not exist." | tee -a "$LOGFILE"
        fi
}

#fuunction to list all group
list_groups() {
    echo "List of all groups:" | tee -a "$LOGFILE"
    cut -d: -f1 /etc/group | tee -a "$LOGFILE"
}

#function to rename a group

rename_group(){
    read -p "Enter a current group name: " oldname
    if getent group $oldname &>/dev/null; then
        read -p "Enter new Group name: " newname
        if getent group $newname &>/dev/null; then
            echo "Group $newname already exists." | tee -a "$LOGFILE"
        else
            groupmod -n "$newname" "$oldname"
            echo "Group $oldname renamed to $newname." | tee -a "$LOGFILE"
        fi
    else 
        echo "Group $oldname does not exist." | tee -a "$LOGFILE"
    fi
}

# function to add user into group

add_user_to_group(){
    read -p "Enter user name: " username
    read -p "Enter group name: " groupname
    if id "$username" &>/dev/null && getent group "$groupname" &>/dev/null; then
        usermod -aG "$groupname" "$username"
        echo "User $username added to group $groupname." | tee -a "$LOGFILE"
    else
        echo "User or group does not exist." | tee -a "$LOGFILE"
    fi
}

while true; do 
    echo ""
    echo "==============================="
    echo "Group Management Menu:"
    echo "==============================="
    echo "1. Add Group"
    echo "2. Delete Group"
    echo "3. List All Group"
    echo "4. Rename Group"
    echo "5. Add user to group"
    echo "6. Exist"
    echo "==============================="
    read -p "Choose an option:" option

case $option in 
    1) add_group ;;
    2) delete_group ;;
    3) list_groups ;;
    4) rename_group ;;
    5) add_user_to_group ;;
    6) echo "Existing..." ; exit 0 ;;
    *) echo "Invalid Option, Please try again." ;;
    esac
done
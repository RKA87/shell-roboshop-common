#!/bin/bash

#Color Code
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NO="\e[0m"
SCRIPT_DIR=$(pwd)

LOG_FOLDER="/var/log/shell-roboshop-common"
LOG_FILE="$LOG_FOLDER/$0.log"

START_TIME=$(date "+%s")

mkdir -p $LOG_FOLDER #because we are passing LOG_FIL in starting itself

echo -e "Script Started at : $(date "+%Y-%m-%d %H:%M:%S")" | tee -a $LOG_FILE

# Check its a Root user or not
check_root_user() {
    USER_ID=$(id -u)
    if [ $USER_ID -ne 0 ]; then
    echo -e "${RED}You should be a root user to execute this script${NO}"
    exit 1
    else
    echo -e "${GREEN}You are a root user, you can continue${NO}"
    fi
}

# Validation Status Check
status_check() {
    if [ $1 -ne 0 ]; then
    echo -e "($(date "+%Y-%m-%d %H:%M:%S")) $2.... ${RED} Failed${NO}"
    exit 1
    else
    echo -e "($(date "+%Y-%m-%d %H:%M:%S")) $2.... ${GREEN} Success${NO}"
    fi
}

# Systemctl Services Status
systemctl_enable() {
    systemctl enable "$app_name" &>>"$LOG_FILE"
    status_check $? "Enabling $app_name service"
}

systemctl_start() {
    systemctl start "$app_name" &>>"$LOG_FILE"
    status_check $? "Starting $app_name service"
}

systemctl_restart() {
    systemctl restart "$app_name" &>>"$LOG_FILE"
    status_check $? "Restarting $app_name service"
}
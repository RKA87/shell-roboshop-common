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

mkdir -p $LOG_FOLDER #because we are passing LOG_FILE in starting itself

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

#Useradd Creation
useradd_creation() {
    id roboshop &>>$LOG_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        status_check $? "Creating roboshop user"
    else
        echo -e "${YELLOW} roboshop user already exists, skipping user creation ${NO}"
    fi
}

#nginx installation
nginx_setup() {
    dnf module disable nginx -y &>>$LOG_FILE
    dnf module enable nginx:1.24 -y &>>$LOG_FILE
    status_check $? "Enabling nginx 1.24 module"
    if dnf list installed nginx -y &>>$LOG_FILE; then
        echo -e "${YELLOW} nginx is already installed, skipping installation${NO}"
    else
        dnf install nginx -y &>>$LOG_FILE
        status_check $? "Installing nginx"
    fi
}

#NodeJS Installation
nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    status_check $? "Disabling NodeJS module"
    
    if dnf list installed nodejs -y &>>$LOG_FILE; then
        echo -e "${YELLOW}NodeJS is already installed, skipping installation${NO}"
    else
        dnf module enable nodejs:24 -y &>>$LOG_FILE
        status_check $? "Enabling NodeJS 24 module"
        dnf install nodejs -y &>>$LOG_FILE
        status_check $? "Installing NodeJS"
    fi
}

#Create applicatio directory install dependencies and build application
application_setup(){
    mkdir -p /app &>>$LOG_FILE
    status_check $? "Creating application directory"

    cd /app &>>$LOG_FILE
    status_check $? "Changing to application directory"

    #download the application code and install dependencies
    curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    status_check $? "Downloading $app_name code"

    cd /app &>>$LOG_FILE
    echo -e "${YELLOW} redirect to /app application directory ${NO}"

    rm -rf /app/* &>>$LOG_FILE
    status_check $? "Removing the existing application code"

    unzip /tmp/$app_name.zip
    status_check $? "${YELLOW} Extracting application code ${NO}"

    echo -e "${YELLOW} Installing dependencies ${NO}"
    cd /app &>>$LOG_FILE
    npm install &>>$LOG_FILE
    status_check $? "Installing $app_name dependencies"
}

systemd_setup() {
    echo -e "${YELLOW} Setting up systemd service file ${NO}"

    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOG_FILE
    status_check $? "Copying $app_name systemd service file"
}

systemd_reload() {
    systemctl daemon-reload &>>$LOG_FILE
    status_check $? "Reloading systemd daemon"
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

# TOTAL_TIME=$(($(date "+%s") - $START_TIME))
# echo -e "Script Completed at : $(date "+%Y-%m-%d %H:%M:%S") and Total Time taken: ${GREEN} $TOTAL_TIME:seconds${NO}" | tee -a $LOG_FILE
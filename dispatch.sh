#!/bin/bash

source ./common.sh
app_name="dispatch"

check_root_user
useradd_creation

dnf install golang -y &>>$LOG_FILE
status_check $? "Installing golang"

#Application setup
mkdir -p /app &>>$LOG_FILE
status_check $? "Creating application directory"

cd /app &>>$LOG_FILE
status_check $? "Changing to application directory"

#download the application code and install dependencies
curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
status_check $? "Downloading $app_name code"

cd /app &>>$LOG_FILE
status_check $? "Changing to application directory"

rm -rf /app/* &>>$LOG_FILE
status_check $? "Removing the existing application code"

unzip /tmp/$app_name.zip
status_check $? "${YELLOW} Extracting application code ${NO}"

echo -e "${YELLOW} Installing dependencies ${NO}"
cd /app &>>$LOG_FILE
go mod init dispatch &>>$LOG_FILE
go get &>>$LOG_FILE
go build &>>$LOG_FILE
status_check $? "Building $app_name application"

systemd_setup

systemd_reload

systemctl_enable

systemctl_start

systemctl_restart
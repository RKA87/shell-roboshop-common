#!/bin/bash

source ./common.sh
app_name="nginx"

check_root_user

nginx_setup

systemctl_enable 

systemctl_start

systemctl_status

#remove files from default nginx content
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
status_check $? "Removing default nginx html content"

#Download frontend content
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$LOG_FILE
status_check $? "Downloading frontend content"

cd /usr/share/nginx/html &>>$LOG_FILE
status_check $? "Changing to nginx html directory"

unzip /tmp/frontend.zip
status_check $? "Extracting frontend content in /usr/share/nginx/html directory"

#Edit the /etc/nginx/nginx.conf file

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
status_check $? "Copying nginx.conf file"

systemctl_restart
status_check $? "Restarting nginx service"
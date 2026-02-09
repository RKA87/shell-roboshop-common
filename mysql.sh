#!/bin/bash

source ./common.sh
app_name="mysqld"

check_root_user

dnf install mysql-server -y &>>$LOG_FILE
status_check $? "Installing MySQL Server"

#set the mysql root password
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
status_check $? "setting up MySQL root password"

systemctl_enable

systemctl_start

systemctl_restart

systemctl status mysqld &>>$LOG_FILE
status_check $? "Checking MySQL service status"
#!/bin/bash

source ./common.sh
app_name="shipping"

check_root_user
useradd_creation
java_app_setup
java_setup

systemd_setup
systemd_reload

systemctl_enable
systemctl_start
systemctl_restart

dnf install mysql -y &>>$LOG_FILE
status_check $? "Installing MySQL client"

mysql -h mysql.rkak87.online -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
status_check $? "Loading schema to MySQL"

mysql -h mysql.rkak87.online -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
status_check $? "Loading app-user schema to MySQL"

mysql -h mysql.rkak87.online -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
status_check $? "Loading master data to MySQL"

systemctl_restart
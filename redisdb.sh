#!/bin/bash

source ./common.sh
app_name="redis"

check_root_user

#module disable enable and installation
dnf module disable redis -y &>>$LOG_FILE
status_check $? "Disabling Redis module"

dnf module enable redis:7 -y &>>$LOG_FILE
status_check $? "Enabling Redis 7 module"

dnf install redis -y &>>$LOG_FILE
status_check $? "Installing Redis"

#change the redis configuration to listen all the interfaces
sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
status_check $? "Updating Redis config to listen on all interfaces using bind ip and protected mode"

systemctl_enable

systemctl_start

systemctl_restart

systemctl status "$app_name"
status_check $? "Checking $app_name service status"
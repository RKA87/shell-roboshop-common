#!/bin/bash

source ./common.sh
app_name="payment"

check_root_user
useradd_creation

#install python3 gcc and python3-devel
dnf install python3 gcc python3-devel -y &>>$LOG_FILE
status_check $? "Installing python3"


python3_app_setup

systemd_setup

systemd_reload

systemctl_enable

systemctl_start

systemctl_restart
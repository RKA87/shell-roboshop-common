#!/bin/bash

source ./common.sh
app_name="cart"

chek_root_user

nodejs_setup

useradd_creation

application_setup

systemd_setup

systemd_reload

systemctl_enable

systemctl_start

systemctl_restart

systemctl status "$app_name"
status_check $? "Checking $app_name service status"
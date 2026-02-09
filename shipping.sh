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
#!/bin/bash

source ./common.sh
app_name="payment"

check_root_user
useradd_creation

#install python3 gcc and python3-devel
if dnf list installed python3 &>>$LOG_FILE; then
    echo -e "${YELLOW} python3 is already installed, skipping installation${NO}"
else
    dnf install python3 gcc python3-devel -y &>>$LOG_FILE
    status_check $? "Installing python3"
fi

python3_app_setup




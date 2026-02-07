#!/bin/bash

source ./common.sh
app_name="mongod"

check_root_user

#Copy mongod repo file to install mongodb
cp $SCRIPT_DIR/mongodb.repo /etc/yum.repos.d/mongodb.repo
status_check $? "Copying MongoDB repo file"

if dnf list installed mongodb-org -y &>>$LOG_FILE; then
    echo -e "${YELLOW}MongoDB is already installed, skipping installation${NO}"
else
    #Install MongoDB
    dnf install mongodb-org -y &>>$LOG_FILE
    status_check $? "Installing MongoDB"
fi

systemctl_enable $app_name

systemctl_start $app_name

# Update the bind_ip
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
status_check $? "Updating bind_ip to allow remote connections"

systemctl_restart $app_name
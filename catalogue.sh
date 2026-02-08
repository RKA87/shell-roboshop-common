#!/bin/bash

source ./common.sh
app_name="catalogue"
MONGODB_HOST="mongodb.rkak87.online"

check_root_user

useradd_creation

nodejs_setup

application_setup

systemd_setup

systemd_reload

systemctl_enable

systemctl_start

systemctl_restart

#Loading Mongodb Repo and its schema's

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOG_FILE

INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
    status_check $? "Loading schema master data to MongoDB"
else
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Products already loaded ... $YELLOW SKIPPING $NO"
fi

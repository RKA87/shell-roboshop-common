#!/bin/bash

source ./common.sh
app_name="rabbitmq-server"

check_root_user

#Copy rabbitmq repo file to install rabbitmq
cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
status_check $? "Copying RabbitMQ repo file"

#Install rabbitmq server
dnf install rabbitmq-server -y &>>$LOG_FILE
status_check $? "Installing RabbitMQ server"

systemctl_enable

systemctl_start

#Create application user and set permissions
rabbitmqctl add_user roboshop roboshop123
status_check $? "Creating RabbitMQ application user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
status_check $? "Setting permissions for RabbitMQ application user"

systemctl_restart
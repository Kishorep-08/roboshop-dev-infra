#!/bin/bash

dnf install ansible -y
# mkdir /var/log/roboshop/
# touch ansible.log
# ansible-pull -U https://github.com/Kishorep-08/ansible-roboshop-roles-tf.git main.yaml

component=$1
environment=$2
REPO_url=https://github.com/Kishorep-08/ansible-roboshop-roles-tf.git
LOGS_DIR=/var/log/roboshop/
REPO_DIR=/opt/roboshop/ansible/
ANSIBLE_DIR=ansible-roboshop-roles-tf

mkdir -p $REPO_DIR
mkdir -p $LOGS_DIR
touch $LOGS_DIR/ansible.log

cd $REPO_DIR

if [ -d $ANSIBLE_DIR ];
then
    cd $ANSIBLE_DIR
    git pull
else
    git clone $REPO_url
    cd $ANSIBLE_DIR
fi

ansible-playbook -e component=$component -e env=$environment main.yaml



#!/bin/bash

dnf install ansible -y
mkdir /var/log/roboshop/ansible.log
ansible-pull -U https://github.com/Kishorep-08/ansible-roboshop-roles-tf.git main.yaml
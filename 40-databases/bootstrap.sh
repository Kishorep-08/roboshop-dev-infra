#!/bin/bash

dnf install ansible -y
ansible pull -U https://github.com/Kishorep-08/ansible-roboshop-roles-tf.git -e component=mongodb main.yaml
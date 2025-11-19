#!/bin/bash

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

sudo yum install -y cloud-utils-growpart

sudo growpart /dev/nvme0n1 4

sudo pvresize /dev/nvme0n1p4

sudo vgdisplay RootVG

sudo lvextend -L 20G /dev/mapper/RootVG-homeVol

sudo lvextend -l +100%FREE /dev/mapper/RootVG-homeVol

sudo xfs_growfs /home
#!/bin/bash -eu
location=$(dirname "$0")

echo "demo - setup and packages"
echo "
[jerakia]
name=Repository for crayfishx/jerakia application.
baseurl=https://rpm.packager.io/gh/crayfishx/jerakia/centos7/stable
enabled=1
gpgcheck=0
" | tee /etc/yum.repos.d/jerakia.repo

yum install -y epel-release
yum install -y jerakia unzip python-requests
cp -f /vagrant/jerakia/policy.d/default.rb /etc/jerakia/policy.d

# install ansible
yum install -y ansible
echo "localhost ansible_connection=local" > /etc/ansible/hosts

# install terraform, packer
mkdir -p ~/bin
curl -LC - -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip
curl -LC - -o /tmp/packer.zip https://releases.hashicorp.com/packer/1.1.3/packer_1.1.3_linux_amd64.zip
unzip -oq /tmp/terraform.zip -d ~/bin
unzip -oq /tmp/packer.zip -d ~/bin

echo "test data lookup without server"
jerakia lookup port

echo "start server"
systemctl start jerakia
systemctl status jerakia -l | tail -n 1

#!/bin/bash

echo "java installation-------------------------------------------------------------------------------------------------------------------------------------------------------------"
#java installation
java -version
sudo apt-get update
sudo apt-get install default-jdk -y
java -version

echo "download and extract wildfly server-------------------------------------------------------------------------------------------------------------------------------------------"
#download and extract wildfly server
cd /opt
sudo wget https://download.jboss.org/wildfly/22.0.1.Final/wildfly-22.0.1.Final.tar.gz
sudo tar -xvzf wildfly-22.0.1.Final.tar.gz
sudo mv wildfly-22.0.1.Final /opt/wildfly

echo "create user and group for wildfly---------------------------------------------------------------------------------------------------------------------------------------------"
#create user and group for wildfly
sudo groupadd wildfly
sudo useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly
sudo chown -R wildfly: wildfly
sudo chmod o+x /opt/wildfly/bin/

echo "change permission and ownership of the wildfly installation directory----------------------------------------------------------------------------------------------------------"
#change permission and ownership of the wildfly installation directory
sudo chown -R wildfly: wildfly
sudo chmod o+x /opt/wildfly/bin/

echo "creating a systemD file for wildfly--------------------------------------------------------------------------------------------------------------------------------------------"
#creating a systemD file for wildfly
cd /etc/
sudo mkdir wildfly
sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/
sudo cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/
sudo chown wildfly: /opt/wildfly/bin/launch.sh
sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/
sudo cp ~/wildfly.service /etc/systemd/system/wildfly.service

echo "start the service--------------------------------------------------------------------------------------------------------------------------------------------------------------"
#start the service
sudo systemctl daemon-reload
sudo systemctl enable wildfly
sudo systemctl start wildfly
sudo systemctl status wildfly
sleep 20

echo "check the log------------------------------------------------------------------------------------------------------------------------------------------------------------------"
#check the log
sudo tail -f /opt/wildfly/standalone/log/server.log





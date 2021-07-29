#!/bin/bash

#be a root user
sudo su
#install Java
apt-get update -y >> /dev/null
apt-get install default-jdk -y >> /dev/null
#create a tomcat group
groupadd tomcat
#create a tomcat user and add to the group
useradd -s /bin/false -g tomcat -d /opt/tomcat
#install tomcat under /opt
cd /tmp
curl -O http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz
#move to /opt
mkdir /opt/tomcat
tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
#update permissions
cd /opt/tomcat
chgrp -R tomcat /opt/tomcat
chmod 700 /opt/tomcat/conf
chown -R tomcat /opt/tomcat
#Systemd Service file 
nano /etc/systemd/system/tomcat.service
######################################################
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
######################################################
#reload daemon
systemctl daemon-reload
#start tomcat
systemctl start tomcat
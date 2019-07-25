#!/bin/bash

set -e
yum update -y
CATALINA_HOME='/opt/tomcat'
TOMCAT_URL="http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.42/bin/apache-tomcat-8.5.42.tar.gz"
TOMCAT_PORT=80

#check if tomcat already installed on server
if [ -d $CATALINA_HOME ]
then
  echo "tomcat already installed on server. Skiping tomcat installation"
  exit 0
else
  echo "continue installation"
fi

#install java
if type -p java;then
  echo "Java already present on machine. Skiping java installation"
else
  sudo yum install -y java-1.8.0-openjdk.x86_64
fi

echo "java installation completed"

#create Tomcat User and Group if not present
echo "user and group creation"

if id "tomcat" >/dev/null 2>&1; then
  echo "user tomcat exists"
else
  echo "Adding user tomcat"
  useradd -n tomcat
fi

if grep -q tomcat /etc/group;then
  echo "group tomcat already present"
else
  sudo groupadd tomcat
fi

usermod -a -G tomcat tomcat

#Install tomcat
rm -rf $CATALINA_HOME
rm -rf *.gz
wget $TOMCAT_URL

mkdir -p $CATALINA_HOME
sudo tar -zxvf apache-tomcat-8.5.42.tar.gz -C $CATALINA_HOME --strip-components=1

#change Tomcat Port
#sed -i "s/8080/$TOMCAT_PORT/g"  $CATALINA_HOME/conf/server.xml

#set permission for $CATALINA_HOME
cd $CATALINA_HOME
chown -R tomcat:tomcat $CATALINA_HOME
chmod -R 755 $CATALINA_HOME


# Create the service init.d script
cat > /etc/systemd/system/tomcat.service <<'EOF'
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat

[Install]
WantedBy=multi-user.targetS
EOF


systemctl daemon-reload
service tomcat start


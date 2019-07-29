#!/bin/sh

set -e

CATALINA_HOME=/opt/tomcat
TEMP_STAGING_DIR=/tmp/codedeploy-staging
WAR_STAGED_LOCATION=$TEMP_STAGING_DIR/webapp/target/*.war

mkdir -p $TEMP_STAGING_DIR
sudo chown -R tomcat:tomcat $WAR_STAGED_LOCATION

# Remove old application artifacts
#if [[ -f $CATALINA_HOME/webapps/*.war ]]; then
sudo rm -rf  $CATALINA_HOME/webapps/*.war
#fi

# Copy the WAR file to the webapps directory
sudo ln -s $WAR_STAGED_LOCATION $CATALINA_HOME/webapps
sudo chmod 755 $CATALINA_HOME/webapps/*.war
sudo chown tomcat:tomcat $CATALINA_HOME/webapps/*.war


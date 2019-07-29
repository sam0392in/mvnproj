#!/bin/sh

set -e

CATALINA_HOME=/opt/tomcat
TEMP_STAGING_DIR=/tmp/codedeploy-staging
WAR_STAGED_LOCATION=$TEMP_STAGING_DIR/webapp/target/*.war

ln -s $WAR_STAGED_LOCATION  $CATALINA_HOME/webapps
chown tomcat:tomcat  $CATALINA_HOME/webapps/*.war
chmod 755  $CATALINA_HOME/webapps/*.war

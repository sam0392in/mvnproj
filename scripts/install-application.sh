#!/bin/sh

set -e

CATALINA_HOME=/opt/tomcat
TEMP_STAGING_DIR=/tmp/codedeploy-staging
WAR_STAGED_LOCATION=$TEMP_STAGING_DIR/webapp/target/*.war

mkdir -p $TEMP_STAGING_DIR

# Remove old application artifacts
#if [[ -f $CATALINA_HOME/webapps/*.war ]]; then
rm -rf  $CATALINA_HOME/webapps/*.war
#fi

# Copy the WAR file to the webapps directory
cp /tmp/codedeploy-staging/webapp/target/*.war $CATALINA_HOME/webapps/
chmod 755 $CATALINA_HOME/webapps/*.war
chown tomcat:tomcat $CATALINA_HOME/webapps/*.war


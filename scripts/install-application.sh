#!/bin/sh

set -e

CATALINA_HOME=/opt/tomcat/
TEMP_STAGING_DIR=/tmp/codedeploy-staging/
WAR_STAGED_LOCATION=$TEMP_STAGING_DIR/webapps/target/webapp.war

mkdir -p $TEMP_STAGING_DIR
# Remove old application artifacts
if [[ -f $CATALINA_HOME/webapps/*.war ]]; then
    rm $CATALINA_HOME/webapps/*.war
fi

# Copy the WAR file to the webapps directory
cp $WAR_STAGED_LOCATION $CATALINA_HOME/webapps/

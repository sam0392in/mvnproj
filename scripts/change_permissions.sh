#!/bin/bash

CATALINA_HOME=/opt/tomcat

chown -R tomcat:tomcat $CATALINA_HOME/webapps/
chmod -R 755 $CATALINA_HOME/webapps/


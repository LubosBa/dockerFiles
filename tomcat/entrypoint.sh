#!/bin/bash

# Check, if Tomcat config folder is empty:
if [[ -z "$(ls -A /tomcat/conf)" ]]; then
  cp -r /opt/tomcat/conf/* /tomcat/conf/
fi

/opt/tomcat/bin/catalina.sh run

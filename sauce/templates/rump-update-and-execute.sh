#!/bin/sh

VER=1.1b

# touchfile
mkdir -p "<%= poweruser_home %>/Dropbox/tmp/sauce/cron-rump/"
DROPBOX_FILE="<%= poweruser_home %>/Dropbox/tmp/sauce/cron-rump/<%= fqdn %>-v$VER.touch"

cd ~/git/puppet-rump && 
	git pull origin master &&  
	git submodule foreach git pull origin master && 
	rump go && 
	touch <%= basepath %>/cron-rump-last-update-v$VER.touch

# If it exists I create a touch :)
if [ -d "<%= poweruser_home %>/Dropbox/tmp/sauce/" ]; then
  rm "<%= poweruser_home %>/Dropbox/tmp/sauce/<%= hostname %>-cron-rump-last-update-v*.touch"
  touch "$DROPBOX_FILE"
  chmod <%=poweruser_name%> "$DROPBOX_FILE"
fi

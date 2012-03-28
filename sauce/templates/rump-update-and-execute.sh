#!/bin/sh

VER=1.3

DROPBOX_DIR="<%= poweruser_home %>/Dropbox/tmp/sauce/cron-rump/"
mkdir -p "$DROPBOX_DIR"
DROPBOX_FILE="$DROPBOX_DIR/<%= fqdn %>-v$VER.touch"

cd ~/git/puppet-rump && 
	git pull origin master &&  
	git submodule foreach git pull origin master && 
	rump go && 
	touch <%= basepath %>/cron-rump-last-update-v$VER.touch

# If it exists I create a touch :)
if [ -d "<%= poweruser_home %>/Dropbox/tmp/sauce/" ]; then
  rm "<%= poweruser_home %>/Dropbox/tmp/sauce/<%= hostname %>-cron-rump-last-update-v*.touch"
  rm -f "<%= poweruser_home %>/Dropbox/tmp/sauce/-cron-rump*.touch"
  touch "$DROPBOX_FILE"
  chown -R <%= poweruser_name %> "$DROPBOX_DIR"
fi

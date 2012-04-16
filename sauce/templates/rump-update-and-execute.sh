#!/bin/sh

VER=1.4

DROPBOX_DIR="<%= poweruser_home %>/Dropbox/tmp/sauce/cron-rump/"
mkdir -p "$DROPBOX_DIR"
DROPBOX_FILE="$DROPBOX_DIR/<%= fqdn %>-v$VER.touch"

# If it exists I create a touch :)
if [ -d "<%= poweruser_home %>/Dropbox/tmp/sauce/" ]; then
  rm "<%= poweruser_home %>/Dropbox/tmp/sauce/<%= hostname %>-cron-rump-last-update-v*.touch" 2>/dev/null
  rm "<%= poweruser_home %>/Dropbox/tmp/sauce/<%= fqdn %>-v*.yml" # 2>/dev/null
  rm -f "<%= poweruser_home %>/Dropbox/tmp/sauce/-cron-rump*.touch" 2>/dev/null
  touch "$DROPBOX_FILE"
  chown -R <%= poweruser_name %> "$DROPBOX_DIR"
fi

cd ~/git/puppet-rump && 
	make &&
	git pull origin master &&  
	git submodule foreach git pull origin master && 
	rump go && 
	touch <%= basepath %>/cron-rump-last-update-v$VER.touch


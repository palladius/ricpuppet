#!/bin/sh

VER=0.9c

cd ~/git/puppet-rump && 
	git pull origin master &&  
	git submodule foreach git pull origin master && 
	rump go && 
	touch <%= basepath %>/cron-rump-last-update-v$VER.touch

# If it exists I create a touch :)
#if [ -f "<%= poweruser_home %>/Dropbox/tmp/sauce/" ]; then
  rm "<%= poweruser_home %>/Dropbox/tmp/sauce/$hostname-cron-rump-last-update-v*.touch"
  touch "<%= poweruser_home %>/Dropbox/tmp/sauce/$hostname-cron-rump-last-update-v$VER.touch"
#fi

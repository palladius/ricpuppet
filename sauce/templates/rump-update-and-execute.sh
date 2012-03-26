#!/bin/sh

VER=0.9a

cd ~/git/puppet-rump && 
	git pull origin master &&  
	git submodule foreach git pull origin master && 
	rump go && 
	touch <%= basepath %>/cron-rump-last-update-v$VER.touch

# If it exists :)
touch ~riccardo/Dropbox/tmp/sauce/cron-rump-last-update-v$VER.touch
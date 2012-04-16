
compile:
	@echo ricpuppet compile target:
	git submodule init && git submodule update

test:
	puppet apply sauce/tests/*.pp --noop --modulepath=.

push:
	git push github master

pull:
	git pull origin master

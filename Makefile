

test:
	puppet apply sauce/tests/*.pp --noop --modulepath=.

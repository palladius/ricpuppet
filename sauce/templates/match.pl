#!/usr/bin/perl
# $Id$
#### /etc/puppet/modules/puppet/bin/math.pl
#### No operator sanity checking, potential security consideration. :)
use strict;
die "Usage: $0 <operand1> <operator> <operand2>\n Example: $0 1 + 2\n Example: $0 2 \\* 8" unless $ARGV[2];

my $result = eval("return $ARGV[0] $ARGV[1] $ARGV[2];"); warn $@ if $@;

print int $result;
#### /etc/puppet/modules/puppet/bin/math.pl END OF FILE

# copied from: http://projects.puppetlabs.com/projects/1/wiki/Cron_Patterns

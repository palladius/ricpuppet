#!/usr/bin/perl
#### /etc/puppet/modules/puppet/bin/randomnum.pl
use strict;
umask 066;

die "Usage: <file basename> <run interval>" unless $ARGV[1];

my $puppetclientetcdir="/etc/puppet/modules/puppet/etc/";
my $keyfile=$puppetclientetcdir.$ARGV[0].".key";

if (!-e $keyfile) {
        my $range=$ARGV[1];
        my $random_number = int rand $range;
        open my $OUT,'>', $keyfile or die "Couldn't write to $keyfile: !$";
        print $OUT $random_number;
        close $OUT;
}

open my $IN,"$keyfile" or die "Couldn't open $keyfile: !$";
foreach my $line (<$IN>) {
  if ($line =~ /^\d+(:?\n|)$/) {
    chomp $line;
    print $line;
    close $IN;
    exit;
  }
}
close $IN;

# If we get to here something is wrong, just print the XKCD random number
# and exit with an error.
print "4";
exit 1;
#### /etc/puppet/modules/puppet/bin/randomnum.pl END OF FILE

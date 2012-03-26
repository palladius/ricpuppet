# Class: nagios
#
# The 'nagios' class ...
#
# Parameters:
#   foo: This parameter is used for... or
#
#   None at the moment

# Actions:
#   ensure that the machine has ...
#
# Sample Usage:
#   class { 'nagios' }

class nagios ($foo = 'bar') {

  package { ['nagios3']: 
    ensure  => 'installed',
  }

} #/Class nagios

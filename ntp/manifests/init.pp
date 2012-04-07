# Class: ntp
#
# The 'ntp' class, simplest in the world.
#
# Parameters:
#   foo: This parameter is used for... or
#
#   None at the moment

# Actions:
#   ensure that the machine has ...
#
# Sample Usage:
#   class { 'ntp' }
class ntp {

  package { "ntp": 
    ensure => installed 
  }

  service { "ntp":
    ensure => running,
  }
}

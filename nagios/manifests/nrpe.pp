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
#   class { 'nagios::nrpe' }

class nagios::nrpe ($foo = 'bar') {
  package { ['nagios-nrpe-server']: 
    ensure  => 'installed',
  }

  ## TEMPLATES
  file { "/etc/nagios/.riccardo-puppet-module-addon.cfg":
    ensure  => present,
    content => template('nagios/nrpe.cfg'),
    require => File[$sauce::dell_basedir],
  }

} #/Class nagios::nrpe

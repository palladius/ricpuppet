# Class: logrotate
#
# The 'logrotate' class ...
#
# Parameters:
#   foo: This parameter is used for... or
#
#   None at the moment

# Actions:
#   ensure that the machine has ...
#
# Sample Usage:
#   class { 'logrotate' }

class logrotate ($foo = 'bar') {
  # Put your class vars here
  $template_version = '0.9.3'

  #package { ['etckeeper','git']:
  #  ensure  => 'installed',
  #}

  #file { '/my/dir':
  #  ensure => 'directory',
  #  owner  => 'root',
  #  mode   => '0755',
  #}

  ## TEMPLATES
  file { "/tmp/puppet-module-logrotate":
    ensure  => present,
    content => template('logrotate/conffile'),
    require => File[$sauce::basedir],
  }

  #just in case, create the importand user that should exist
  #user { 'foo':
  #    ensure     => 'present',
  #    password   => 'YouWillNeverGuessThis21387frebjhq43',
  #    managehome => true;
  #  }

} #/Class logrotate

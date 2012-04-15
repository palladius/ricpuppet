# Class: vnc4server
#
# The 'vnc4server' class installs vnc4server with
# a secret password you can never guess!!!
#
# Parameters:
#   foo: This parameter is used for... or
#
#   None at the moment

# Actions:
#   ensure that the machine has ...
#
# Sample Usage:
#   class { 'vnc4server' }

class vnc4server () {

  package { ['vnc4server','vnc-java']:
    ensure  => 'installed',
  }

  file { '/root/.vnc/':
    ensure => 'directory',
    owner  => 'root',
    mode   => '0755',
  }
  file { '/root/.vnc/passwd':
    ensure => 'present',
    owner  => 'root',
    content => template('vnc4server/passwd'),
    mode   => '0600',
    require => File[$sauce::basedir],
  }

} #/Class vnc4server

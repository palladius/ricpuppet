# Class: dropbox
#
# The 'dropbox' class ...
#
# Parameters:
#   foo: This parameter is used for... or
#
#   None at the moment

# Actions:
#   ensure that the machine has ...
#
# Sample Usage:
#   class { 'dropbox' }

class dropbox (user = 'riccardo') {

  #package { ['etckeeper','git']: 
  #  ensure  => 'installed',
  #}

  #file { '/my/dir':
  #  ensure => 'directory',
  #  owner  => 'root',
  #  mode   => '0755',
  #}

  ## TEMPLATES
  file { "/etc/apt/sources.list.d/dropbox.list":
    ensure  => present,
    content => template('dropbox/dropbox.list'),
  }

} #/Class dropbox

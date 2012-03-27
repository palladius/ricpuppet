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

  package { ['nautilus-dropbox']: 
    ensure  => 'installed',
  }

  # apt-get -f install dopo?!?

  ## TEMPLATES
  file { "/etc/apt/sources.list.d/dropbox.list":
    ensure  => present,
    content => template('dropbox/dropbox.list'),
  }

} #/Class dropbox

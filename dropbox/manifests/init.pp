# Class: dropbox
#
# Installs Dropbox on a Linux machine
#
# Parameters:
#   user: This parameter will be used in the future for the
#    username. At the moment I cant cos it would mean putting
#    user and password in github :)
#
# Actions:
#   ensure that the machine has Dropbox package installed
#
# Sample Usage:
#   include 'dropbox'
#
class dropbox ($user = 'riccardo') {
  #confine operatingsystem => Debian / Ubuntu

  package { ['nautilus-dropbox']: 
    ensure  => 'installed',
    require => File['/etc/apt/sources.list.d/dropbox.list'],
  }

  # apt-get -f install dopo?!?
  # logs in as '$user' and '$password' ...

  ## TEMPLATES
  file { '/etc/apt/sources.list.d/dropbox.list':
    ensure  => present,
    content => template('dropbox/dropbox.list'),
  }

} #/Class dropbox

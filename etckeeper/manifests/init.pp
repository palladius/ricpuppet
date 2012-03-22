# Definition: etckeeper
#
# This class installs etckeeper (forcing conf with git) and ensures it is
# running.
#
# Parameters:
# - None
#
# Actions:
# - Install etckeeper
#
# Requires:
# - Nothing
#
# Sample Usage:
#   include etckeeper
#

class etckeeper {
  include vanilla

  # Used in the template
  case $operatingsystem {
    fedora: {
      $highlevel_package_manager = 'yum'
      $lowlevel_package_manager  = 'rpm'
    }
    ubuntu: {
      $highlevel_package_manager = 'apt'
      $lowlevel_package_manager  = 'dpkg'
    }
    default: {fail("Etckeeper doesn't know how to handle ${operatingsystem}")}
  }

  package { 'etckeeper':
    ensure => installed;
  }

  file {'/etc/etckeeper/etckeeper.conf':
    ensure  => present,
    content => template('etckeeper/etckeeper.conf'),
      # could work even without but I want to be sure it overwrites the conf..
    require => Package['etckeeper'];
  }

  Exec { path => [
    '/usr/bin',
    '/usr/sbin',
    '/opt/dell/bin',
  ] }

  exec {'etckeeper_init once':
      command => 'etckeeper init',
      creates => '/etc/.git',
      require => File['/etc/etckeeper/etckeeper.conf'];
  }
}
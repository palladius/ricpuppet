# Class: puppet
#
# Installs Puppet with nice bits and pieces.
#
# Parameters:
#   $development_machine (dflts to false):
#     if true installs additional packages
#
# Actions:
#   ensure that the machine has puppet installed the Debian way
#
# Sample Usage:
#   class { 'puppet':
#     development_machine => true
#   }
#
class puppet ($development_machine = false) {
  # Put your class vars here
  $template_version = '0.9.5'

  package { ['rubygems','augeas-tools']:
    ensure  => 'installed',
  }

  # installing thru apt might be a bad idea... i have 0.24 version on a VM (!!)
  package { ['puppet','rump']:
    ensure   => installed,
    provider => 'gem',
    require  => Package['rubygems']
  }

  if ($development_machine) {
    package { ['puppet-el','vim-puppet']:
      ensure  => 'installed',
    }
  }

  # TODO ensure packages puppet and facter are NOT installed by ubuntu (we want
  # the rubygems)

} #/Class puppet

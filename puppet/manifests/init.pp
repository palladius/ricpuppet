# Class: puppet
#
# Installs Puppet with nice bits and pieces.
#
# Parameters:
#   $development_machine (dflts to false):
#     if true installs additional packages

# Actions:
#   ensure that the machine has puppet installed the Debian way
#
# Sample Usage:
#   class { 'puppet':
#     development_machine => true
#   }

class puppet ($development_machine = false) {
  # Put your class vars here
  $template_version = '0.9.3'

  package { ['puppet','augeas-tools']:
    ensure  => 'installed',
  }

  if ($development_machine) {
    package { ['puppet-el','vim-puppet']:
      ensure  => 'installed',
    }
  }

  # installs gem rump?!? I like it!

} #/Class puppet

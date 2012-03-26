# Class: sauce::legacy
#
# This class removes puppet stuff left by old scripts :)
#
# Parameters:
#   None at the moment
#
# Actions:
#   ensure that the instalaltion is clean and neat
#
# Sample Usage:
#   class { 'sauce':
#     machine_description => 'optional description'
#   }
class sauce::legacy () {

  # Moved to another place
  file { "$basepath/bashrc.inject":
    ensure  => absent,
  }
  file { "$roothome/.bashrc.riccardo":
    ensure  => absent,
  }
  file { "$poweruser_home/.bashrc.riccardo":
    ensure  => absent,
  }
 file { "$dropbox_sauce_dir/hostinfo-$::fqdn.yml":
    ensure  => absent,
 }
 file { "/opt/riccardo/":
    ensure  => absent,
 }
  ############
   # rm -rf '/opt/riccardo'
   
}
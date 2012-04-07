# Class: sauce::legacy
#
# This class removes puppet stuff left by old scripts :)
# Pointless on new machines, but cleans up stuff on old ones :)
#
# Parameters:
#   None at the moment
#
# Actions:
#   ensure that the installation is clean and neat
#
# Sample Usage:
#   include sauce::legacy
#
class sauce::legacy () {

  file { [
    "${sauce::basepath}/bashrc.inject",
    "${sauce::roothome}/.bashrc.riccardo",
    "${sauce::poweruser_home}/.bashrc.riccardo",
    "${sauce::dropbox_sauce_dir}/hostinfo-${::fqdn}.yml",
    "${sauce::dropbox_sauce_dir}/-*.yml",
    '/opt/riccardo/', # rm -rf '/opt/riccardo' ?!?
  ]:
    ensure  => absent,
  }

}
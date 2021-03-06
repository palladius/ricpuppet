# Class: manazza
#
# This class setup a user account with home and ssh connectivity
#
# Parameters:
#   user_name: the name for the user account
#
# Actions:
#   creates user, sets his home, sets is "authorized_keys" file, and 
#   make sure the machine is ssh capable
#
# Sample Usage:
#   class manazza{'bob': user_name => 'bob', }
#
class manazza ( $user_name ) {
  
  # the extropy base class setup ssh... amongst other goodness  
  # include base
  # include sauce # maybe better?

  manazza::user_with_homedir_and_sshkeys {'testpuppetric1': ensure => 'present'; }
  manazza::user_with_homedir_and_sshkeys {'testpuppetric2': ensure => 'present'; }
  
  $user_home = "/home/$user_name"
  
  file {$user_home: 
    ensure => 'directory';
  }
  
  user {$user_name:
    ensure      => present,
    managehome  => true,
    shell       => '/bin/bash',
    home        => $user_home,
    require     => File[$user_home]
  }
  
  file {"$user_home/.ssh": 
    ensure => 'directory';
  }
  
  file {"$user_name_athorized_keys":
    ensure  => present,
    path    => "$user_home/.ssh/authorized_keys",
    source  => "manazza/authorized_keys",
    mode    => '0600',
    owner   => '$user_name',
    require     => [File["$user_home/.ssh"], User[$user_name]];
  }
  
  test {'test_for_hanson_class': script_name => 'hansdon/module_manazza_test.sh.erb'; }
  
}
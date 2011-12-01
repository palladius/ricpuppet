# Type: test
#
# This type is a wrapper to create users
#
# Parameters:
#   $user_name:
#     the name of the user
#
#   $ensure:
#     defaults to present
#     other valid value is absent 
#     anything else will be equivalent to absent
#
# Actions:
#   Creates a create a user, sets its home and ssh authorized keys and ensure ssh capabilities to the system
#
# Sample Usage:
#   manazza::type {'bob': ensure => 'present'; }
#
define manazza::type ($user_name, $ensure = 'present'){

  # the extropy base class setup ssh... amongst other goodness...  
  include base

  if $ensure == 'present' {
    $ensure_dir = 'directory'
    $ensure_filtered = 'present'
  } else {
    $ensure_dir = 'absent'
    $ensure_filtered = 'absent'
  }

  $user_home = "/home/$user_name"

  file {$user_home: 
    ensure => $ensure_dir;
  }

  user {$user_name:
    ensure      => $ensure_filtered,
    managehome  => true,
    shell       => '/bin/bash',
    home        => $user_home,
    require     => File[$user_home]
  }

  file {"$user_home/.ssh": 
    ensure => $ensure_dir;
  }

  file {"$user_name_athorized_keys":
    ensure  => $ensure_filtered,
    path    => "$user_home/.ssh/authorized_keys",
    source  => "manazza/authorized_keys",
    mode    => '0600',
    owner   => '$user_name',
    require     => [File["$user_home/.ssh"], User[$user_name]];
  }
}
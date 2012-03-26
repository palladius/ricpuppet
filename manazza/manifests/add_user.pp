# Defined type: 
# copied from http://itand.me/using-puppet-to-manage-users-passwords-and-ss
#
# manazza::add_user { rrunner:
#   email    => "road.runner@acme.com",
#   uid      => 5001
# }
#
define manazza::add_user ( $email, $uid ) {

            $username = $title

            user { $username:
                    comment => "$email",
                    home    => "/home/$username",
                    shell   => "/bin/bash",
                    uid     => $uid
            }

            group { $username:
                    gid     => $uid,
                    require => user[$username]
            }

            file { "/home/$username/":
                    ensure  => directory,
                    owner   => $username,
                    group   => $username,
                    mode    => 750,
                    require => [ user[$username], group[$username] ]
            }

            file { "/home/$username/.ssh":
                    ensure  => directory,
                    owner   => $username,
                    group   => $username,
                    mode    => 700,
                    require => file["/home/$username/"]
            }

            # exec { "/narnia/tools/setuserpassword.sh $username":
            #         path            => "/bin:/usr/bin",
            #         refreshonly     => true,
            #         subscribe       => user[$username],
            #         unless          => "cat /etc/shadow | grep $username| cut -f 2 -d : | grep -v '!'"
            # }

            # now make sure that the ssh key authorized files is around
            file { "/home/$username/.ssh/authorized_keys":
                    ensure  => present,
                    owner   => $username,
                    group   => $username,
                    mode    => 600,
                    require => file["/home/$username/"]
            }
    }

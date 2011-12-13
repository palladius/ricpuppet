# Definition: vanilla
#
# This class installs and configures a Vanilla system (base) for the Dell Cloud environment
#
# Parameters:
#   none
#
# Actions:
# - Install & Configures git, ssh-server, creates /opt/rcarlesso/
#
# Requires:
# - Nothing
#
# Sample Usage:
#  include vanilla
# or:
#  class {'vanilla': }
#
class vanilla () {
    package {'git':
        ensure => latest,
    }

	# TODO refactor into openssh-server module!
    service {'openssh-server':
        ensure  => running,
        enable  => true,
        require => Package['openssh-server'],
    }
    
    include 'backup:client'
    
    ## The root password will be blank on a new install
    #exec {'set-root-password-if-blank':
    #    onlyif  => "/usr/bin/mysql -uroot --password=",
    #    command => "/usr/bin/mysql -uroot --password= -e \"UPDATE mysql.user \
    #               SET Password=PASSWORD('$root_passwd') WHERE \
    #               User='root'; \
    #               FLUSH PRIVILEGES;\"",
    #    require => Service["mysql"],
    #}
}

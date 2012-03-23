# Definition: cielcio
#
# This class installs and configures Gerrit for the Dell Cloud environment
#
# Parameters:
# - The $port to configure the host on
#
# Actions:
# - Install & Configures git, cielcio, nginx and gitweb
#
# Requires:
# - Nothing
#
# Sample Usage:
#  include cielcio
# or:
#  class {'cielcio': }
#
#define mysql::db ($user, $passwd, $root_passwd) {
#    class {'mysql':
#        root_passwd => $root_passwd,
#    }#
#
#    exec {'create-db':
#        unless => "/usr/bin/mysql -u$user -p$passwd $name",
#        command => "/usr/bin/mysql -uroot -p$root_passwd -e \"create database \
#                   $name; grant all on $name.* to $user@localhost identified \
#                   by '$passwd'; ALTER DATABASE reviewdb charset=latin1; \
#                   FLUSH PRIVILEGES;\"",
#        require => Class["mysql"],
#    }
#}


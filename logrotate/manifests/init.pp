# ensure logrotate package is installed
# ensure that /etc/logrotate.d exists
# drop files in /etc/logrotate.d
#
# Note. Should only work on Ubuntu/Debian. Debug it on Redhat.
class logrotate::base {

  package { logrotate:
    ensure => installed,
  }

  file { "/etc/logrotate.d":
    ensure => directory,
    owner => root,
    group => root,
    mode => 755,
    require => Package[logrotate],
  }

}

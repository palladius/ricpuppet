
## Base class that imports the specific subclasses (Mac, Linux, ...)

class sauce::os {

  # Used by facter to import node.pp stuff :)
  file { "$basepath/TODO-osbase-${::operatingsystem}":
    ensure  => present,
    content => $::operatingsystem,
    require => File[$basepath];
  }

}

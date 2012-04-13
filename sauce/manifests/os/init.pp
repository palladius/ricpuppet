
## Base class that imports the specific subclasses (Mac, Linux, ...)
#
# class sauce::os {
#
#   # Used by facter to import node.pp stuff :)
#   file { "$sauce::basepath/TODO-osbase-${::operatingsystem}":
#     ensure  => present,
#     content => $::operatingsystem,
#     require => File[$sauce::basepath];
#   }
#
# }

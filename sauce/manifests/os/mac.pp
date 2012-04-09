


class sauce::os::mac {

  # Used by facter to import node.pp stuff :)
  file { "$basepath/TODO-macosx-riccardo":
    ensure  => present,
    require => File[$basepath];
  }

  # Do some specific OSX specific stuff

}

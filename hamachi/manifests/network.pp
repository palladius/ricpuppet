# defined type: hamachi::network
# (name from defined type,password,autojoin=true)
#
# Example: hamachi create puppet-dundrum 'CH4NG3M3!'
#
define hamachi::network($pass,$autojoin=true) {
  include sauce
  include hamachi
  # Do all the things you'd normally do, using $type_server as needed
  
  file {"$sauce::basepath/hamachi-network-TODO-${name}.touch":
    ensure  => file,
    content => "name: {$name}\npassword: ${pass}\nautojoin: ${autojoin}",
    require => File[$sauce::basepath],
  }

}

# Sample:
# hamachi::network{'puppet-dundrum': pass => 'CH4NG3M3!' }

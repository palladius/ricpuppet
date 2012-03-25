# defined type: hamachi::network
# (name from defined type,password,autojoin=true)
#
# Example: hamachi create puppet-dundrum 'CH4NG3M3!'
#
define hamachi::network($pass,$autojoin=true) {
  include sauce
  include hamachi
  # Do all the things you'd normally do, using $type_server as needed
  
  file {"$sauce::basepath/hamachi-network-TODO-${name}.yml":
    ensure  => file,
    content => "Hamachi Network Riccardo:\n name: {$name}\n password: ${pass}\n autojoin: ${autojoin}\n",
    require => File[ $sauce::basepath ],
  }

  if ($autojoin) {
    exec {"Joins and touches network $name":
      command => "hamachi join '$name' '$pass' && touch $sauce::basepath/hamachi-joined-$name.ok",
      creates => "$sauce::basepath/hamachi-joined-$name.ok",
      path    => $sauce::normal_path;
    }
  }

}

# Sample:
# hamachi::network{'puppet-dundrum': pass => 'CH4NG3M3!' }

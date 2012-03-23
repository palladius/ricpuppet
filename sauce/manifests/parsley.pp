# Defined type: sauce::parsley
define sauce::parsley ($content, $diary = 'default') {
  include sauce
  # Do all the things you'd normally do, using $type_server as needed
  
  file {"$parsley_dir/${diary}::${name}.txt":
    ensure  => file,
    content => "== $diary::$name ==\n\n$content\n",
    require => File[$sauce::parsley_dir],
  }

}

#node 'myserver.domain.com' {
#  sauce::parsley { 'mynote':
#    content => "Content of the note"
#  }
#}

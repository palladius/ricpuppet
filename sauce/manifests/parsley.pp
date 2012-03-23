# Defined type: sauce::parsley
define sauce::parsley ($content, $diary = 'default') {
  include sauce
  # Do all the things you'd normally do, using $type_server as needed
  
  file {"$parsley_dir/${diary}-${name}.txt":
    ensure  => file,
    content => "== $diary::$name ==\n\n$content\n",
    mode    => 0644,
    #owner   => $user,
    #require => User[$user],
   }
}

#node 'myserver.domain.com' {
#  sauce::parsley { note1:
#    content => "Content of the note"
#  }
#}

# Defined Type: sauce::parsley
#
# This class configures a small 'diary' file with some notes, tyipicalli
# Host description and stuff like that.
#
# Parameters:
#   None at the moment
#
# Actions:
#   Adds the diary file in /opt/palladius/
#
# Sample Usage:
#   sauce::parsley { 'Note Name':
#     content => "This note is an example"
#   }




define sauce::parsley ($content, $diary = 'default') {
  include sauce

  file {"${sauce::basepath_parsley_dir}/${diary}::${name}.txt":
    ensure  => file,
    content => "== $diary::$name ==\n\n$content\n",
    require => File[$sauce::basepath_parsley_dir],
  }

}

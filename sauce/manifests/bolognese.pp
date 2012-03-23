# very saucy flavor, for development machines (test gems, ...)
# Coloured vim, irb, ...
# $flavour = 'bolognese/ragù'
class sauce::bolognese() {
  $bolognese_packages = [
    'polygen', 'cowsay',    # I can't live without this stupid stuff :)
    'libsqlite3-ruby', # database
    'libldap2-dev', 'libldap-ruby1.8',    # Service LDAP
    'libxslt1-dev', 'libxml2-dev',        # WebRat gem
    'libxmpp4r-ruby', # Debian package for XMPP ruby that works
  ]

  $bolognese_gems = [
    'xmpp4r-simple' ,   # Jabber notifications
    'puppet-lint',      # for puppet
    'ruby-mp3info',     # hahaha...
    'firewatir', 'nokogiri', #  Web

    # Rails
    'nifty-generators', 'rails', 'gcal4ruby', 'capistrano',
    'cucumber', 'webrat', 'geoip',

    'ym4r', 'gcal4ruby', # Google
    'scruffy', # Graphs
    'wirble', # coloured IRB yay!
    'sinatra', # too cool to be true
  ]

}
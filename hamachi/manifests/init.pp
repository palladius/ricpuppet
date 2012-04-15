# Definition: hamachi
#
# This class installs logmein-hamachi on Debian systems.
#
# Bugs: up to 0.9.4, it works but doesnt trigger the apt-get -f install
#
# Parameters:
# - None (possibly a hostname)
#
# Actions:
# - Install hamachi
#
# Requires:
# - Nothing
#
# Sample Usage:
#   include hamachi
#
class hamachi($hamachi_hostname = $::hostname) {
  require sauce

  $hamachiver = '0.9.5'
  # architecture: i386 or what...
  $deb_filename = "logmein-hamachi_2.1.0.17-1_$::architecture.deb"
  #$deb_filename = 'logmein-hamachi_2.1.0.17-1_i386.deb' # this works
  $deb_path= "$sauce::basepath/downloadz/$deb_filename"

  if ($::operatingsystem == 'Darwin') {
    # installs on Mac
    notify{ 'Dont know how the hell to install hamachi on a Mac (yet)': }
  } 

  if ($::operatingsystem == 'Ubuntu') {
    # installs on Ubuntu
    notify{'Lets do it on Debian/Ubuntu': }

  # TODO check architecture
  # 1. Copies the deb file
  file { $deb_path:
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => "puppet:///modules/hamachi/$deb_filename",
  }

  # 2. Installs package
  package { 'logmein-hamachi':
    # ensure => installed,
    ensure   => latest,
    provider => dpkg,
    source   => $deb_path,
    notify   => Exec["fix hamachi install once ver $hamachiver"],
    require  => [
      File[$deb_path],
      File["$sauce::basepath/downloadz"],
    ];
  }

  #3. apt-get -f install
  # This should be executed just after installation
  # I make it version dependant so if I change the logic I just have to
  # add the version to make it recheck this script :)
  exec {"fix hamachi install once ver $hamachiver":
      command => "/usr/bin/apt-get -f install -y && touch \
  '$sauce::basepath/downloadz/puppet-hamachi.v$hamachiver-fixed.touch'",
      creates =>
        "$sauce::basepath/downloadz/puppet-hamachi.v$hamachiver-fixed.touch",
      require => [Package['logmein-hamachi'],
        File["$sauce::basepath/downloadz"]];
  }

  service {'logmein-hamachi':
    ensure  => running,
    require => Package['logmein-hamachi'];
  }

  # TODO rename to username
  # "hamachi set-nick $hamachi_hostname"
  file { "$sauce::basepath/downloadz/puppet-hamachi.TODO.hostname":
      ensure  => present,
      content => "#TODO execute this once:\nhamachi set-nick $hamachi_hostname",
      require => File["$sauce::basepath/downloadz"];
  }

  } # Ubuntu stuff
}

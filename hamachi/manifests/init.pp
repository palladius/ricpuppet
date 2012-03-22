# Definition: etckeeper
#
# This class installs logmein-hamachi on Debian systems
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
class hamachi($hamachi_hostname = $hostname) {
  require vanilla
  $hamachiver = '0.9.1'
  # architecture: i386 or what...
  $deb_filename = "logmein-hamachi_2.1.0.17-1_$::architecture.deb"
  #$deb_filename = 'logmein-hamachi_2.1.0.17-1_i386.deb' # this works
  $deb_path= "$vanilla::basepath/downloadz/$deb_filename"

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
    require  => File[$deb_path],
    # TODO give different source
  }

  # This should be executed just after installation
  # I make it version dependant so if I change the logic I just have to
  # add the version to make it recheck this script :)
  exec {"fix hamachi install once ver $hamachiver":
      command => "/usr/bin/apt-get -f install -y && touch \
  '$vanilla::basepath/downloadz/puppet-hamachi.v$hamachiver-fixed.touch'",
      creates =>
        "$vanilla::basepath/downloadz/puppet-hamachi.v$hamachiver-fixed.touch",
      require => Package[ 'logmein-hamachi' ];
  }

  service {'logmein-hamachi':
    ensure  => running,
    require => Package['logmein-hamachi'];
  }

  # TODO rename to username
  # "hamachi set-nick $hamachi_hostname"
  file { "$vanilla::basepath/downloadz/puppet-hamachi.TODO.hostname":
      ensure  => present,
      content => "#TODO execute this once:\nhamachi set-nick $hamachi_hostname",
  }
}
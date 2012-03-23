# Class: sauce (flavour: 'in bianco')
#
# This class configures the dev servers in a standard way common to ALL
# machines.
#
# Parameters:
#   None at the moment
#
# Actions:
#   ensure that the machine has an agreed directory structure.
#   Creates dirs/files as per wiki docs (/opt/riccardo/, ...)
#
# Sample Usage:
#   class { 'sauce':
#     machine_description => 'optional description'
#   }
class sauce ($machine_description = 'Sorry, no info provided') {
  $version = '1.0.02'
  $verbose = true
  $basepath = '/opt/riccardo'
  $root_path_addon = "$basepath/bin:$basepath/sbin:/var/lib/gems/1.8/bin/"
  $user_path_addon = "$basepath/bin"
  $flavour = 'in bianco'
  $history = '
1.0.02 20120323 Added my favorite rubygems support :)
1.0.01 20120322 Added bashrc to Riccardo as well
0.9.12 20120322 Added hostinfo in YAML representation :)
0.9.12 20120322 Machine Description added!
0.9.11 20120322 History made variable, merged programmatically with old branch
0.9.10 20120322 Adding mandatory packages
0.9.9  20120322 Adding $saucedir/downloadz
0.9.8  20120321 Adding host history
0.9.7  2011xxxx Cant remember, i guess all the DIR infrastructure
0.9.1  2011???? Added LICENSE,README,.bashrc, Common HEADER'

  # Interesting parameters collected by facter
  $facter_fun_facts = [
    'hostname','domain','fqdn','ipaddress',
    'physicalprocessorcount',
    'virtual','machine_description',
    'operatingsystem','operatingsystemrelease',
    'architecture','uniqueid','productname'
  ]
  
  # sauce packages
  $mandatory_packages = [
    'bash-completion' , # how can u live without it?
    'gitk',             # ditto (git is called git-core on 10.04 so maybe this),
    'libnotify-bin',    # notify-send for sending messages.
    'rubygems',         # I know, it would be better to have them installed from source but.... hey... this is puppet!
  ]

  $mandatory_gems = [
    'xmpp4r-simple' ,   # Jabber notifications
  ]


  $sauce_template_header = "\
#############################################################################
# !!!BEWARE!!!
#############################################################################
# This file is managed by Puppet (Vanilla v$version).
# Change at your own risk!
#############################################################################"

  #if (defined('machine_description')) {
  #  $machine_description = "Dan is right: $machine_description"
  #} else {
  #  $machine_description = "UNDEFINED DESCRIPTION ($::machine_description)"
  #}

  # guarantees these base packages are installed everywhere :)
  package {$mandatory_packages:
    ensure => 'installed'
  }

  # Ruby gems we want installed
  package { $mandatory_gems:
    provider => 'gem',
    ensure   => installed,
    require  => Package[[rubygems]]
  }

  Exec { path => [
    '/usr/bin',
    '/usr/sbin',
    "$basepath/bin",
    "$basepath/sbin",
  ] }

  # If you put them in order, puppet will do the correct thing
  # and won't need the dependencies ;)
  $sauce_skeleton_dirs = [
    $basepath,
    "$basepath/bin",
    "$basepath/downloadz",
    "$basepath/etc",
    "$basepath/man",
    "$basepath/sbin",
    "$basepath/tmp",
    "$basepath/var",
    "$basepath/var/log",
  ]

  file { $sauce_skeleton_dirs:
    ensure => 'directory',
    owner  => 'root',
    #group => "riccardo",
    mode   => '0755',
    # otherwise normal users can't get in
  }

  file { '/root/HISTORY_SYSADMIN':
    ensure => present
    # Write if not exists the following:
    #   # Please keep this up to date!
    #   $DATE Added HISTORY FILE and PUPPETIZED HOST
    #   HOSTNAME: hostname -f
    #   DISTRO:   lsb_release -a
    #content => template('sauce/README'),
    #require => File[$basepath],
  }

  # puts the version in /opt/riccardo/VERSION
  file { "$basepath/VERSION":
    ensure  => present,
    content => $version,
    require => File[$basepath],
  }

  file { "$basepath/MACHINE_DESCRIPTION":
    ensure  => present,
    content => "$machine_description\n",
    require => File[$basepath],
  }

  ## TEMPLATES
  file { "$basepath/LICENSE":
    ensure  => present,
    content => template('sauce/LICENSE'),
    require => File[$basepath],
  }

  file { "$basepath/README":
    ensure  => present,
    content => template('sauce/README'),
    require => File[$basepath],
  }

  file { "$basepath/TODO":
    ensure  => present,
    content => template('sauce/TODO'),
    require => File[$basepath],
  }

  file { "$basepath/HISTORY":
    ensure  => present,
    content => template('sauce/HISTORY'),
    require => File[$basepath],
  }

  file { "$basepath/HOSTINFO.yml":
    ensure  => present,
    content => template('sauce/HOSTINFO.yml'),
    require => File[$basepath],
  }

  file { '/root/.bashrc.riccardo':
    ensure  => present,
    content => template('sauce/bashrc.riccardo'),
    require => File[$basepath],
  }
  # TODO refactor in a defined type
  file { '/home/riccardo/.bashrc.riccardo':
    ensure  => present,
    owner   => 'riccardo',
    group   => 'riccardo',
    content => template('sauce/bashrc.riccardo'),
    require => File[$basepath],
  }

  # Mabnual exec (inelegant)
  exec {'echo "if [ -f /root/.bashrc.riccardo ] ; \
then source /root/.bashrc.riccardo ; fi" \
>> /root/.bashrc':
    unless  => 'grep "then source /root/.bashrc.riccardo" /root/.bashrc',
    path    => '/bin';
  }

  # Include the inject file...
  file { "$basepath/bashrc.inject":
    ensure  => present,
    content => template('sauce/bashrc.inject'),
    require => File[$basepath];
  }

  # catting for user Riccardo.
  # TODO make it modular for user XXXX'
  exec {"cat '$basepath/bashrc.inject' >> ~riccardo/.bashrc":
    unless  => 'grep "bashrc.inject START" ~riccardo/.bashrc',
    path    => '/bin',
    require => File["$basepath/bashrc.inject"];
  }

  # Symlinking our logs into /var/log/riccardo/
  file {'/var/log/riccardo':
    ensure  => "$basepath/var/log",
    force   => true,
    require => File["$basepath/var/log"],
  }

  # For automated backup pulls
  user { 'ricbackup':
    ensure     => present,
    password   => 'YouWillNeverGuessThis21387frebjhq43',
    managehome => true,
  }

}
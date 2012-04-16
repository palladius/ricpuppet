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
#   Defins important dirs like:
#   - $roothome (HOME of root, usually /root but not on Mac)
#   - $basepath (basedir for all my stuff...)
#
# Sample Usage:
#   include  'sauce':
class sauce () {
  include sauce::legacy   # remove legacy stuff
  #include sauce::os       # Adds OS specific code! (Recafctorung Mac OS/X out of here!)
  #include vcsrepo

  $version = '1.2.18'
  $verbose = true
  $basepath = '/opt/palladius'
  $default_poweruser_name  = 'riccardo'
  $default_poweruser_email = "root@$::fqdn"
  $basepath_parsley_dir = "$basepath/parsley"
  $root_path_addon = "$basepath/bin:$basepath/sbin:/var/lib/gems/1.8/bin/"
  $normal_path = '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin'
  $user_path_addon = "$basepath/bin"
  $dropbox_sauce_dir = "$poweruser_home/Dropbox/tmp/sauce/" # pers stuff
  $flavour = 'in bianco' # TODO remove this: its not changeable. Maybe a Facter?
  $history = '
1.2.18 20120416 Adding /root/git
1.2.17 20120416 Adding cutting edge technology called Makefile :)
1.2.16 20120415 Adding gem :rest_client for geo_ip facter!
1.2.15 20120411 Adding geo_city and geo_stuff to facter interesting things
1.2.14 20120409 Adding sauce::os stuff (refactoring operating system stuff).
1.2.13 20120407 Linting, fixing bugs, IT WORKS now.
1.2.12 20120403 nothing really, just restored old file after a few days missing!
1.2.11 20120330 updated cron dropbox cleanup
1.2.10 20120329 Added VcsRepo for Sakura
1.2.09 20120327 Changed the updater script. Better dropbox. Symlink to /etc/
1.2.08 20120327 Changed License to Creative Commons
1.2.07 20120327 Minor adds
1.2.06 20120326 My first working function
1.2.05 20120326 Adding legacy to remove old stuff :)
1.2.04 20120326 Changed basedir to /opt/palladius/ and dflt username. Cron cleanup
1.2.03 20120326 Minor changes. Huge bug fixed. Migrating cron job to file
1.2.02 20120325 Added dropbox_sauce_dir
1.2.01 20120325 cron also updates submodules.. (should..)
1.1.04 20120325 Adding apache2, better facter and Mac support (wow!)
1.1.03 20120325 Adding sendmail. Using "roothome" from facter
1.1.02 20120324 bugfixes
1.1.01 20120324 Adds root dir. Adds Cron to autoupdate itself!!! (my dream)
1.0.04 20120324 Patched to make it work on a Mac :)
1.0.03 20120323 Added A LOT of packages and amenities
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
    'architecture','uniqueid','productname',
    'memorysize', 'processor', 'processorcount',             # RAM e uP
    'geo_city', 'mynetwork', 'gic_home', 'interesting_dirs', # available with Riccardo GIC facts
  ]

  # stuff which is big so I want to see it but NOT in the synoptic
  $facter_big_facts = [
    'sshrsakey', # big but interesting :)
  ]

  $library_user_home = get_home  # test ruby library

  # Facts defined by me
  $facter_custom_facts = [
    'roothome',
    'poweruser_name', # from site.pp / here
    'poweruser_name_facter', #facter one (for testing purposes)
    'poweruser_group',  'poweruser_home',
      'poweruser_exists', 'poweruser_email',
      'poweruser_simplegroup', # 'poweruser_grp',
    'nmap_installed', # TODO better
    'whoami', # just for testing
    'richome', # ditto
    'library_user_home'
  ]

  # Common to Debian, Ubuntu and Mac
  #$mandatory_packages = [
  #  'bash-completion' ,              # how can u live without it?
  #]

  # sauce debian packages
  $mandatory_debian_packages = [
    'gitk',                          # I need git at least for rump
    'libnotify-bin',                 # notify-send for sending messages.
    'rubygems',                      # I know, it would be better to have them installed from source but.. hey... this is puppet!
    'links', 'lynx', 'wget',         # For web
    'ruby-full', 'build-essential',  # Suggested by DHH Ruby Wiki
    'fping','nmap','traceroute',     # Networking basics, wtf! :)
    'locales' ,          # For some bug on missing LC_TYPE..
    'language-pack-en',  # For some bug on missing LC_TYPE..
    'sendmail', # to send emails
    'apache2',  # to expose my info :)
    #'puppet',   # NO! Already required otherwise!
  ]

  $mandatory_gems = [
    'xmpp4r-simple' ,   # Jabber notifications
    'ric',              # Self gratification :)
    'puppet',           # Self gratification :)
    'rest-client',      # geo_ip.rb facter
    #sakura             # TODO implement
    #rump               # not really needed yet.. :)
  ]

  # TODO use vcsrepo
  $github_repos = [
    'palladius/sakura',
    'palladius/puppet-rump',
  ]

  $sauce_template_header = "\
#############################################################################
# !!!BEWARE!!!    File managed by Puppet (Sauce v$version).
#                 Change at your own risk
#############################################################################"

  if (defined('cluster_machine_description')) {
    $machine_description = $cluster_machine_description
  } else {
    $machine_description = "UNDEFINED DESCRIPTION for $::hostname. Please define 'cluster_machine_description' within the cluster."
  }
  if (defined('cluster_poweruser_email')) {
    $poweruser_email = $cluster_poweruser_email
  } else {
    $poweruser_email = $default_poweruser_email
  }

$cluster_poweruser_name  = 'riccardo'
  if (defined('cluster_poweruser_name')) {
    $poweruser_name = $cluster_poweruser_name
  } else {
    $poweruser_name = $default_poweruser_name
  }

  # guarantees these base packages are installed everywhere :)
  #package {$mandatory_packages:
  #  ensure => 'installed'
  #}

  case $::operatingsystem {
    debian: {
      package {$mandatory_debian_packages:
        ensure => 'installed'
      }
    }
    ubuntu: {
      package {$mandatory_debian_packages:
        ensure => 'installed'
      }
    }
    darwin: {
      notify {"on Mac OS/X ('${::operatingsystem}') I should leverage the XCode, me thinks": }
    }
    default: {
      notify {"sauce doesn't know how to apt-get install my debian packages for '${::operatingsystem}' OS! \
  Expect some packages NOT to be correctly installed": }
    }
  }

  # Ruby gems we want installed
  package { $mandatory_gems:
    ensure   => installed,
    provider => 'gem',
  }

  Exec { path => [
    '/usr/bin',
    '/usr/sbin',
    "$basepath/bin",
    "$basepath/sbin",
  ] }

  # If you put them in order, puppet will do the correct thing
  # and won't need the dependencies ;)
  $sauce_skeleton_root_dirs = [
    $basepath,
    "$basepath/bin",
    "$basepath/downloadz",
    "$basepath/etc",
    "$basepath/man",
    "$basepath/sbin",
    "$basepath_parsley_dir",
    "$basepath/tmp",
    "$basepath/var",
    "$basepath/var/log",
    '/root/git',
    '/var/www',
  ]

  $sauce_skeleton_poweruser_dirs = [
    "$poweruser_home/Dropbox",
    "$poweruser_home/Dropbox/tmp/",
    $dropbox_sauce_dir,
  ]

  # my first symlink
  file {"/etc/palladius/":
    ensure  => link,
    target  => "$basepath/etc",
    require => File["$basepath/etc"],
  }

  file { $sauce_skeleton_root_dirs:
    ensure => 'directory',
    owner  => 'root',
    group  => $poweruser_group,
    mode   => '0755',
    # otherwise normal users can't get in
  }
  # this should belong to poweruser :)
  file { $sauce_skeleton_poweruser_dirs:
    ensure => 'directory',
    owner  => $poweruser_name,
    # otherwise normal users can't get in
  }

  file { "$roothome/HISTORY_SYSADMIN":
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

  file { "$basepath/hostinfo.yml":
    ensure  => present,
    content => template('sauce/hostinfo.yml'),
    require => File[$basepath],
  }

  # For apache visibility!
  file { "/var/www/hostinfo-$hostname.txt":
    ensure  => present,
    content => template('sauce/hostinfo.yml'),
    require => [File[$basepath],File['/var/www']],
  }

  file { "$roothome/.bashrc.sauce":
    ensure  => present,
    owner   => $poweruser_name,
    content => template('sauce/bashrc.sauce'),
    require => File[$basepath],
  }

  ############
  # TODO refactor in a defined type
  file { "$poweruser_home/.bashrc.sauce":
    ensure  => present,
    owner   => $poweruser_name,
    group   => $poweruser_group,
    content => template('sauce/bashrc.sauce'),
    require => File[$basepath],
  }

  file { "$dropbox_sauce_dir/${::fqdn}-v${sauce::version}.yml":
    ensure  => present,
    owner   => $poweruser_name,
    group   => $poweruser_group,
    content => template("sauce/hostinfo.yml"),
    require => File[$dropbox_sauce_dir],
  }
  # Mabnual exec (inelegant)
  exec {"echo \"if [ -f $roothome/.bashrc.sauce ] ; \
then source $roothome/.bashrc.sauce ; fi\" \
>> $roothome/.bashrc":
    unless  => "grep \"then source $roothome/.bashrc.sauce\" $roothome/.bashrc",
    path    => $normal_path;
  }

  # Used by facter to import node.pp stuff :)
  file { "$basepath/etc/sauce.conf":
    ensure  => present,
    content => template('sauce/sauce.conf'),
    require => File["$basepath/etc"];
  }
  file { "$basepath/sbin/rump-update-and-execute.sh":
    ensure  => present,
    mode    => '0755',
    content => template('sauce/rump-update-and-execute.sh'),
    require => File["$basepath/sbin"];
  }

  # Include the inject file...
  file { "$basepath/tmp/bashrc.inject":
    ensure  => present,
    content => template('sauce/bashrc.inject'),
    require => File[$basepath];
  }

  # catting for user Riccardo.
  # TODO make it modular for user XXXX'
  exec {"cat '$basepath/tmp/bashrc.inject' >> ~riccardo/.bashrc":
    unless  => 'grep "bashrc.inject START" ~riccardo/.bashrc',
    path    => $normal_path,
    require => File["$basepath/tmp/bashrc.inject"];
  }

  # Symlinking our logs into /var/log/riccardo/
  file {'/var/log/riccardo':
    ensure  => "$basepath/var/log",
    force   => true,
    require => File["$basepath/var/log"],
  }

  #TODO If mac, DONT managehome, else DO :)
    # For automated backup pulls, doesnt work on Mac
    user { 'ricbackup':
      ensure     => present,
      password   => 'YouWillNeverGuessThis21387frebjhq43',
    }

  if ($::id == 'root') {} else {
    fail("Sorry(id), this module requires you to be ROOT \
(not '$::id'), dont use sudo. Be brave! :)")
  }
  if ($::whoami == 'root') {} else {
    fail("Sorry(whoami), this module requires you to be ROOT \
(not '$::whoami'), don't use sudo. Be brave! :)")
  }

  #vcsrepo { '/root/git/puppet-vcsrepo-test-sakura':
  #  ensure   => present, # latest?
  #  provider => git,
  #  source   => 'git://github.com/palladius/sakura.git'
  #}

  cron { "periodically update rump from Riccardo github and execute":
    ensure      => present,
    command     => "$basepath/sbin/rump-update-and-execute.sh",
    user        => 'root',
    environment => [
      "PATH=$normal_path:$root_path_addon",
      "MAILTO=${sauce::cronemail}"],
    minute      => [1,16,31,46],
    require     => File["$basepath/sbin/rump-update-and-execute.sh"],
  }

}

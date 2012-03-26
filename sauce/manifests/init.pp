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
#   class { 'sauce':
#     machine_description => 'optional description'
#   }
class sauce () {
  include sauce::legacy   # remove legacy stuff
  
  $version = '1.2.05'
  $verbose = true
  $basepath = '/opt/palladius'
  $basepath_parsley_dir = "$basepath/parsley"
  $root_path_addon = "$basepath/bin:$basepath/sbin:/var/lib/gems/1.8/bin/"
  $normal_path = '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin'
  $user_path_addon = "$basepath/bin"
  $dropbox_sauce_dir = "$poweruser_home/Dropbox/tmp/sauce/" # pers stuff
  $flavour = 'in bianco'
  $default_poweruser_name = 'inbianco'
  $history = '
1.2.05 20120326 Adding legacy to remove old stuff :)
1.2.04 20120326 Changed basedir to /opt/palladius/ and so dflt username, Cron cleanup
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
    'architecture','uniqueid','productname'
  ]

  $library_user_home = get_home($poweruser_name)  # test ruby library
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

  # sauce debian packages
  $mandatory_debian_packages = [
    'bash-completion' ,              # how can u live without it?
    'gitk',            # ditto (git is called git-core on 10.04 so maybe this)
    'libnotify-bin',                 # notify-send for sending messages.
    # I know, it would be better to have them installed from source but....
    # hey... this is puppet!
    'rubygems',
    'links', 'lynx', 'wget',         # For web
    #'libxmpp4r-ruby',                # Jabber library for my notify scripts
    'ruby-full', 'build-essential',  # Suggested by DHH Ruby Wiki
    'fping','nmap','traceroute',     # Networking basics, wtf! :)
    # For some bug on missing LC_TYPE..
    'locales' ,
    'language-pack-en',
    'sendmail', # to send emails
    'apache2',  # to expose my info :)
  ]

  $mandatory_gems = [
    'xmpp4r-simple' ,   # Jabber notifications
    'ric',              # Self gratification :)
    'puppet',           # Self gratification :)
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
    $machine_description = "UNDEFINED DESCRIPTION. Please define 'cluster_machine_description' within the cluster."
  }

$cluster_poweruser_name  = 'riccardo'
  if (defined('cluster_poweruser_name')) {
    $poweruser_name = $cluster_poweruser_name
  } else {
    $poweruser_name = $default_poweruser_name
  }
  
  # guarantees these base packages are installed everywhere :)
  package {$mandatory_packages:
    ensure => 'installed'
  }
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
    #require  => Package['rubygems']
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
    '/var/www',
  ]

  $sauce_skeleton_poweruser_dirs = [
    "$poweruser_home/Dropbox",
    "$poweruser_home/Dropbox/tmp/",
    $dropbox_sauce_dir,
  ]

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
    #group  => $poweruser_group, # should be automatical
    #mode   => '0755',
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

  file { "$dropbox_sauce_dir/$::fqdn.yml":
    ensure  => present,
    owner   => $power_user,
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
    mode   => '0755',
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
      #managehome => true,  # gives error on Mac
    }

#  if ($::richome == undef) {
#    fail("Facter shouold have defined \$richome for me in sauce! richome='$richome'")
#  } else {
#    notify{"RICHOME correctly defined! richome='$richome'": }
#  }

  if ($::id == 'root') {} else {
    fail("Sorry(id), this module requires you to be ROOT (not '$id'), dont use sudo. Be brave! :)")
  }
  if ($::whoami == 'root') {} else {
    fail("Sorry(whoami), this module requires you to be ROOT (not '$id'), dont use sudo. Be brave! :)")
  }

  cron { "periodically update rump from Riccardo github and execute":  
      ensure      => present,
      command     => "$basepath/sbin/rump-update-and-execute.sh",
      user        => 'root',
      environment => ["PATH=$normal_path:$root_path_addon","MAILTO=$cronemail"], # this is from site.pp
      minute      => [1,16,31,46],
      require     => File["$basepath/sbin/rump-update-and-execute.sh"],
  }
  # copied from http://projects.puppetlabs.com/projects/1/wiki/Cron_Patterns
  cron { "fruncton test":
    ensure  => present,
    command => "#echo ip_to_cron(2) returns #{ ip_to_cron(2) }",
    user    => 'root',
    minute  => ip_to_cron(2)
  }
}

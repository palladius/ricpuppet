# Class: vanilla
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
#   class { 'vanilla' }

class vanilla () {
  # Please populate the HISTORY package
  $version = "0.9.1"
  $verbose = true
  $basepath = "/opt/riccardo"
  $root_path_addon = "$basepath/bin:$basepath/sbin"
  $user_path_addon = "$basepath/bin"
  $vanilla_template_header = "\
#############################################################################
# BEWARE! This file is managed by Puppet (Vanilla v$version).
# Change at your own risk!
#############################################################################"

  Exec { path => [
    "/usr/bin",
    "/usr/sbin",
    "$basepath/bin",
    "$basepath/sbin",
  ] }

  # If you put them in order, puppet will do the correct thing and won't need the dependencies ;)
  $vanilla_skeleton_dirs = [
    "$basepath",
    "$basepath/bin",
    "$basepath/etc",
    "$basepath/man",
    "$basepath/sbin",
    "$basepath/tmp",
    "$basepath/var",
    "$basepath/var/log",
  ]

  file { $vanilla_skeleton_dirs:
    ensure => "directory",
    owner  => "root",
    #group  => "riccardo",
    mode   => 750,
    # normal users can't get in
  }

  # puts the version in /opt/riccardo/VERSION
  file { "$basepath/VERSION":
    ensure => present,
    recurse => true,
    content => "$version",
    require => File[$basepath],
  }

  ## TEMPLATES
  file { "$basepath/LICENSE":
    ensure  => present,
    content => template('vanilla/LICENSE.erb'),
    require => File[$basepath],
  }

  file { "$basepath/README":
    ensure => present,
    content => template('vanilla/README.erb'),
    require => File[$basepath],
  }

  file { "$basepath/TODO":
    ensure => present,
    content => template('vanilla/TODO.erb'),
    require => File[$basepath],
  }

  file { "$basepath/HISTORY":
    ensure => present,
    content => template('vanilla/HISTORY.erb'),
    require => File[$basepath],
  }

  file { "/root/.bashrc.riccardo":
    ensure => present,
    content => template('vanilla/bashrc.riccardo.erb'),
    require => File[$basepath],
  }

  # Symlinking our logs into /var/log/riccardo/
  file {"/var/log/riccardo":
    force   => true,
    ensure  => "$basepath/var/log",
    require => File["$basepath/var/log"],
  }

  # For automated backup pulls
  user { "ricbackup":
    ensure     => "present",
    password   => 'YouWillNeverGuessThis21387frebjhq43',
    managehome => true,
  }

}
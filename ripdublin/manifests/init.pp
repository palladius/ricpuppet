
# Riccardo, try this:
# puppetd -vo --no-daemonize --noop --server rivendell.crowbar-test3.palladius.eu

# KNOWN BUGS: looks like there is a filebucket error.
import "/etc/puppet/modules/ripdublin/manifests/*.pp" 

class ripdublin {
	$ripdublin_version = '0.1.1'
        notify{'RipdublinGreeting': message => "Welcome to ripdublin v$ripdublin_version" }

        Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin" }
        #Exec { path => [ '/sbin', '/bin', '/usr/bin', '/usr/local/bin', '/opt/dell/bin', '/usr/bin/puppetripdublin/' ] }


	$files_dir = '/etc/puppet/modules/ripdublin/files/' # I guess this is a Danielism rather than a good practice..

        notify{ "OS":
		message => $operatingsystem ? {
			'Darwin' => 'This is a Mac',
			'Ubuntu'  => 'Ubuntu! The concept is an ethic or humanist philosophy focusing on peoples allegiances and relations with each other',
			default  => "This is neither a Mac or Ubuntu: its a '$operatingsystem'",
		}
        }

        group { 'clouddev':
            ensure => present,
            #members => 'sergio,david,riccardo,andrea,francesco,daniel'
        }

        # Backup Puppet User (maybe?)
        user { "cloudypuppet":
		name =>  "cloudypuppet",
		ensure     => present,
		gid        => 'backup',
		shell      => '/bin/bash',
		home       => '/home/cloudypuppet/',
		managehome => true,
	}

	cron { riccardo_logrotate:
	    command => '/usr/sbin/logrotate',
            user    => root ,
            hour    => 12,
            minute  => 34,
            ensure  => present,
        }

        # adds a line to .bashrc unless it exists already...
        exec { "/bin/echo -en \"# These two lines were added by Puppet\nsource /root/bashrc_puppet_aliases\" >> /root/.bashrc":
            path   => "/usr/bin:/usr/sbin:/bin",
            unless => "fgrep /root/bashrc_puppet_aliases /root/.bashrc"
        }

	# TODO ask Daniel how to require cowsay package first :)
	exec { "/bin/echo Welcome to this Puppet enabled host | cowsay -f ghostbusters > /etc/motd.puppet":
          unless => "[ -f /root/.PLEASE.DONT_OVERWRITE_MOTD ]" ,
          creates => '/etc/motd.puppet', # this is an optimization to only do it ONCE if the file doesnt exist.
          require =>  Package["cowsay"],
	}

        exec { "echo Warning a new puppet version has been deployed. Please touch /root/.PLEASE.DONT_SCREAM to silence | wall":
              path => "/usr/bin:/usr/sbin:/bin",
              unless => "[ -f /root/.PLEASE.DONT_SCREAM ]"
        }

	package {'cowsay':     ensure => present }
	package {'netcat':     ensure => present }
	package {'traceroute': ensure => present }
	package {'netcat6':    ensure => present }
	#package {'sshd':       ensure => present }

	service { 'ssh':
		ensure => running,
		enable => true,
		hasstatus => true,
		hasrestart => true,
	}

	augeas { "sshd_config":
           context => "/files/etc/ssh/sshd_config",
	   changes => [
		#"set /files/etc/ssh/sshd_config/PermitRootLogin yes",
		"set PermitRootLogin yes",
		],
           notify => Service["ssh"] # restart if ...
	}

	# Host<<| |>>

        # Riccardo SSH key from his Dell Notebook ('pappardell')
        ssh_authorized_key { "Riccardo_Carlesso@WN7X64-1JQL0Q1":
          ensure => "present",
          type   => "ssh-dss",
          key    => 'AAAAB3NzaC1kc3MAAACBAPBUYn/vrnrK5fOQ74EEu9KcP07M+sTotPmcLojOKtDKnmsJ3IOlne3jqAYFI92CCV4HaLWw4MC+/nrRIEq49yI9S5l3bTj8aPwUWcwfgboY0YHq0b9snQPYgNdFJecgjj2AaY5qYCX26IZtkGD1C1OcNls3cbeRTytFtjFM6GPtAAAAFQCdptx/zRn4HzxsVe09YoXwjOwDbQAAAIEAtsHhS7NCYENGSRp0v0V/BTROxC9lecmGM+iXFDbJOgZ01pDAiqBAdqepZonswjFYKRwyP03ehVD+/GTiRmdHB1RBy/g7HieVkuezrJS6QkYYu6VfUcqcLWsxFixd1D43ZWa/z8CW68fUf28wyHUUfngIwMamfuijH69p+kWT6qUAAACAOFHPJBcQYzdZMUfbtXXCRzohHBQB5dtU+2KO9kVU0DlUrpPwjKO3/6pB1kODM6dEoXK9Eev7RngjvWwsBVBiaAgv5DRagVFs8gYpoU18pbYekRaY4pBrjGW5grlqiUjs8In5KzLWKPvrIMahrddRiUPrBSYTYHCVeByL2Y2YdV4=',
          user   => "root",
        }
}


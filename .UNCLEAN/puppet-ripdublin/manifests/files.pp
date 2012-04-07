
class ripdublin::files {
	$ripdublin_files_version = '0.0.1'
	$header = "# Puppet RipDublin::Files v$ripdublin_files_version"

        notify{'RipdublinFilesGreeting': message => "Welcome to ripdublin::files v$ripdublin_files_version" }

        File { backup => main }

	# I guess this is a Danielism rather than a good practice..
	$files_dir = '/etc/puppet/modules/ripdublin/files/'
	file {"/etc/cron.d/ripdublin": content	=> template("/etc/puppet/modules/ripdublin/files/crond_ripdublin"), backup	=> false, }

	file {"/root/bashrc_puppet_aliases":  
		content => template("/etc/puppet/modules/ripdublin/files/puppet_aliases"),
		backup  => false,
	}
        file { '/usr/bin/ripdublin-help': 
		mode => 755, 
		backup => false, 
		content => template("/etc/puppet/modules/ripdublin/files/ripdublin-help"),
	}

        # Remove unwanted files based on specific criteria. Multiple criteria are OR’d together, 
        # so a file that is too large but is not old enough will still get tidied.
        #tidy { "/tmp": age     => "1w", recurse => true, matches => [ "[0-9]pub*.tmp", "*.temp", "tmpfile?", "puppet*" ] }

        #file { '/usr/bin/ripdublin': ensure => directory , }

        #file { '/usr/bin/ripdublin/puppet-help': mode => 755, backup => false, content => 'echo help for Puppet as provided by ripdublin module', require => File['/usr/bin/ripdublin/'], }

        file { '/etc/ripdublin/puppet.conf': mode    => 755, backup  => false, content => "# Test content put by Puppet $header", }

        file { '/etc/motd': mode    => 644 , backup  => true, content => '# Welcome to motd written by puppet', }

	file { '/etc/ripdublin/': ensure => directory, backup => true, 
	}

	file { "/etc/ripdublin/puppet_bashrc_common_symlink": ensure => link, backup => false, target => "/root/.bashrc", } 

}

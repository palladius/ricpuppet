
 # DavidB workstation: Gedeon 172.16.1.191
 # Ric Win Notebook:   wn7x64-1jql0q1.dub.emea.dell.com

class vanilla {


	$username = 'ricpuppet'
	$homedir = "/home/$username" 

	user { $username:
		ensure     => present ,
		managename => true ,
		shell      => '/bin/bash' ,
		home       => $homedir,
		require    => File[$homedir]

	}

	package { 'ssh':
		ensure => present ,
	}

	file { "$homedir/.ssh/":
		ensure    => directory ,
	}

	file { "$homedir/.ssh/authorized_keys.puppet":
		ensure     => present,
		source     => "puppet:///modules/vanilla/authorized_keys",
		mode       => '0600',
		owner      => "$username",
		require    => [
			File["$username/.ssh"],
			User[$username],
		], 
	}



}

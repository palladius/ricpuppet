
		# Gedeon 172.16.1.191
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



}

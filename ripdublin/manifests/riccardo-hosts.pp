
# Riccardo, try this:
# puppetd -vo --no-daemonize --noop --server rivendell.crowbar-test3.palladius.eu

# KNOWN BUGS: looks like there is a filebucket error.

class ripdublin::richosts {
	$hosts_version = "0.0.3"

	host { "admin-node-r369.crowbar-test3.palladius.eu": ip => "192.168.124.10",  host_aliases => ["admin-node-r369","chef-server","crowbar","admin-node"], }
	host { "rivendell.crowbar-test3.palladius.eu":   ip => "192.168.124.29",  host_aliases => ["rivendell","puppetmaster","foreman","puppet","Puppetmaster"], 
		#comment => 'foreman is needed for Foreman to work properly!',
		# puppet is needed by Foreman as dflt master...
	}
	host { "moria.crowbar-test3.palladius.eu":       ip => "192.168.124.30",  host_aliases => "moria", }
	host { "rivendell2.crowbar-test3.palladius.eu":  ip => "192.168.193.128", host_aliases => ["rivendell2","rivendell-dhcp","dev"], }
	host { "moria2.crowbar-test3.palladius.eu":      ip => "192.168.193.131", host_aliases => ["moria2","moria-dhcp","firewall"] }
	host { "wunderbar":       ip => "188.40.90.151", host_aliases => "wunderbar.palladius.eu", 
		#comment => 'Riccardo specific Server' 
	}
	host { "localhost":       ip => "127.0.0.1", host_aliases => ['me','lo','myself'] } # I always wanted to 'ping myself'
	host { "test":       ip => "127.0.0.42", ensure => absent }
}

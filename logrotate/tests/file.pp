logrotate::file { "puppetmaster-provaric-masterhttp.log": 
 log => "/var/log/puppet.provaric/masterhttp.log",
 options => [ 'compress', 'weekly', 'rotate 4' ],
 postrotate => "[ -e /etc/init.d/puppetmaster-production ] && /etc/init.d/puppetmaster-production condrestart >/dev/null 2>&1 || true",
}
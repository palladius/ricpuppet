define dns::resolvconf($search, $nameservers) {
    file {
        "/etc/cron.d/puppet-backup-generic-backup-etc-and-var":
            owner => "root",
            group => "root",
            mode  => "644",
            # it might not work. TODO test it
            content => template("dns/etc/cron.d/puppet-backup-generic-backup-etc-and-var");
    }
}


define logrotate::file( $log, $options, $postrotate = "NONE" ) {

        # $options should be an array containing 1 or more logrotate directives (e.g. missingok, compress)

        include logrotate::base

        file { "/etc/logrotate.d/${name}":
                owner => root,
                group => root,
                mode => 644,
                content => template("logrotate/logrotate.tpl"),
                require => File["/etc/logrotate.d"],
        }

}
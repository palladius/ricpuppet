define nagios::command($command, $remote, $ensure="present") {
  if ($ensure == "present") {
    $file_ensure = "file"
  } else {
    $file_ensure = "absent"
  }


  if $remote {
    # Use NRPE
    include ::nagios::nrpe::package
    include ::nagios::nrpe::server

    file {
      "/etc/nagios/nrpe.d/$name.cfg":
        ensure => $file_ensure,
        require => Class["nagios::nrpe::package"],
        notify => Class["nagios::nrpe::server"],
        content => "command[$name]=$command\n";
    }
  } else {
    # Not remote, we're a nagios server so add a specific command.

    $command_template = "
      # Generated by puppet from Nagios::Command[$name] 
      define command {
        command_name <%= name %>
        command_line <%= command %>
      }
    "

    nagios::config {
      "command-$name":
        ensure => $ensure,
        content => inline_template($command_template);
    }
  }
}

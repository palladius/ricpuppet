# Serious stuff that anybody might want to 'steal'


# Home of current user, which should ALWAYS be root.
Facter.add("roothome") do
    setcode do
        ENV['HOME']
    end
end

Facter.add(:nmap_installed) do
  is_installed = false
  os = Facter.value('operatingsystem')
  case os
    when "RedHat", "CentOS", "SuSE", "Fedora"
      is_installed = system 'rpm -q nmap > /dev/null 2>&1'
    when "Debian", "Ubuntu", 'Darwin' # yes, my darwin has apt-get and dpkg -l thanks to XCode!
      is_installed = system 'dpkg -l nmap > /dev/null 2>&1'
    else
  end
end

Facter.add(:whoami) do
  setcode do
    Facter::Util::Resolution.exec('whoami').chomp
  end
end

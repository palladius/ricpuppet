# Serious stuff that anybody might want to 'steal'


# Home of current user, which should ALWAYS be root.
Facter.add("roothome") do
    setcode do
        ENV['HOME']
    end
end

# maybe fixed!
Facter.add(:nmap_installed) do
 setcode do
  is_installed = false
  program = 'nmap' # i could make it more generic...
  os = Facter.value('operatingsystem')
  case os
    when "RedHat", "CentOS", "SuSE", "Fedora"
      is_installed = system 'rpm -q nmap > /dev/null 2>&1'
    when "Debian", "Ubuntu", 'Darwin' # yes, my darwin has apt-get and dpkg -l thanks to XCode!
      is_installed = system 'dpkg -l nmap > /dev/null 2>&1'
    else
      raise "Dont know how to get this on '$os' os!"
  end
  return is_installed
 end
end

#/usr/bin/whoami
Facter.add(:whoami) do
  setcode do
    return Facter::Util::Resolution.exec('/usr/bin/whoami').chomp rescue "whoami_error('#{$!}')"
  end
end

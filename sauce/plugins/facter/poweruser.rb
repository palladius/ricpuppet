# See: http://docs.puppetlabs.com/guides/custom_facts.html

# Poweruser defined in the cluster, i.e.:
# $power_user  = 'riccardo'

# $power_user defined in the cluster!
require 'facter'

# SHOULDNT BE HERE!!!
Facter.add(:poweruser_name_facter) do
  setcode do
      File.readlines(scope.lookupvar('sauce::basepath') + '/etc/sauce.conf').select{|l| 
        l.match /^cluster_poweruser_name/ 
      }[0].split(': ')[1].chomp rescue 'riccardo'
  end
end

# HOME of poweruser
Facter.add(:poweruser_home) do
    setcode do
      # there must be a better way
      # so it works but its debuggable
      userhome = File.expand_path("~" + Facter.value(:poweruser_name_facter) ) || "/home/#{$dflt_poweruser_name}//////"
      throw "Home not found for user '#{Facter.value(:poweruser_name_facter)}': aborting" unless File.exists?(userhome)
      userhome
    end
end

Facter.add(:poweruser_exists) do
    setcode do
      File.exists?( Facter.value(:poweruser_home) )
    end
end

Facter.add(:poweruser_email) do
    setcode do
      File.readlines( scope.lookupvar('sauce::basepath') + '/etc/sauce.conf').select{|l|
        l.match /^cronemail/ 
      }[0].split(': ')[1].chomp rescue "'Some Email Error: #{$!}' <palladiusbonton@gmail.com>"
    end
end

Facter.add(:poweruser_group) do
  setcode do
    username = Facter.value('poweruser_name_facter')
    case Facter.value('operatingsystem')
       when "Darwin"
         'staff'
       else
         username || 'riccardo'
    end
  end
end

Facter.add('poweruser_simplegroup') do
 setcode do
  os = Facter.value('operatingsystem')
    case os
      when "RedHat", "CentOS", "SuSE", "Fedora"
        #system "ls -al /home/#{username}/.bashrc | awk '{print $4}'"
        Facter.value(:poweruser_name_facter)
      when "Debian", 'Ubuntu'
        Facter.value(:poweruser_name_facter) # in ubuntu its the same!
      when "Darwin"
        :staff
      else
        "Unknown OS: '#{os}'"
    end
 end
end


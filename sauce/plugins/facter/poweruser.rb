
# Poweruser defined in the cluster, i.e.:
# $power_user  = 'riccardo'

# $power_user defined in the cluster!
require 'facter'

#$dflt_poweruser_name = 'riccardo_dflt' # on my CYGWIN im 'riccardo_carlesso'

# must be first!
Facter.add(:poweruser_name) do
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
      userhome = File.expand_path("~" + Facter.value(:poweruser_name) ) || "/home/#{$dflt_poweruser_name}//////"
      throw "Home not found for user '#{Facter.value(:poweruser_name)}': aborting" unless File.exists?(userhome)
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
      File.readlines( $sauce::basepath + '/etc/sauce.conf').select{|l| 
        l.match /^cronemail/ 
      }[0].split(': ')[1].chomp
    end
end

Facter.add(:poweruser_group) do
  setcode do
    username = Facter.value('poweruser_name')
    case Facter.value('operatingsystem')
       when "Darwin"
         'staff'
       else
         username || 'riccardo'
    end
  end
end

# # See: http://docs.puppetlabs.com/guides/custom_facts.html
# Facter.add(:poweruser_group) do
#   setcode do
#     return File.stat(Facter.value(:poweruser_home)).gid # rescue Facter.value(:poweruser_name)
#     sample_file = File.expand_path(Facter.value(:poweruser_home) + "/.bashrc")
#     if File.exist?(sample_file)
#       arr_ls = Facter::Util::Resolution.exec("/bin/ls -al '#{sample_file}'").chomp.split rescue nil
#       if (arr_ls.kind_of?(Array)) 
#         arr_ls[3]
#       end
#       # otherwise it should return nil and the other definition should yield! :)
#       #ls -al ~riccardo/.bashrc | awk '{print $4}'
#     else
#       Facter.value(:poweruser_name)
#     end
#   end
# end

Facter.add('poweruser_simplegroup') do
 setcode do
  os = Facter.value('operatingsystem')
    case os
      when "RedHat", "CentOS", "SuSE", "Fedora"
        #system "ls -al /home/#{username}/.bashrc | awk '{print $4}'"
        Facter.value(:poweruser_name)
      when "Debian", 'Ubuntu'
        Facter.value(:poweruser_name) # in ubuntu its the same!
      when "Darwin"
        :staff
      else
        "Unknown OS: '#{os}'"
    end
 end
end


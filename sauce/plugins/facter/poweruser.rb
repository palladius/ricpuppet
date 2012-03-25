
# Poweruser defined in the cluster, i.e.:
# $power_user  = 'riccardo'

# $power_user defined in the cluster!
require 'facter'

#$dflt_poweruser_name = 'riccardo_dflt' # on my CYGWIN im 'riccardo_carlesso'

# on Mac it's 'staff'. On Ubuntu/Debian it equals the username
# Facter.add(:poweruser_group) do
#   has_weight 50 # Low
#   setcode do
#     :staff
#   end
# end

def username2
  #username = cluster_poweruser_name
  name = File.readlines(scope.lookupvar('sauce::basepath') + '/etc/sauce.conf').select{|l| 
    l.match /^cluster_poweruser_name/ 
  }[0].split(': ')[1].chomp rescue 'riccardo'
  return name
  #=> "riccardo"
  #username = Facter.value('cluster_poweruser_name').to_s #|| cluster_poweruser_name # || $dflt_poweruser_name
  #username = scope.lookupvar('::cluster_poweruser_name').to_s
  #raise "Sorry, username '#{username}' not found! Aborting" unless username.length > 0
  #username
end


# HOME of poweruser
Facter.add(:poweruser_home) do
    setcode do
      # there must be a better way
      # so it works but its debuggable
      userhome = File.expand_path("~" + Facter.value(:poweruser_name) ) || "/home/#{$dflt_poweruser_name}//////"
      throw "Home not found for user '': aborting" unless File.exists?(userhome)
      userhome
    end
end

Facter.add(:poweruser_exists) do
    setcode do
      File.exists?(File.expand_path(Facter.value(:poweruser_name)))
    end
end

Facter.add(:poweruser_name) do
    setcode do
      username2()
    end
end

Facter.add(:poweruser_email) do
    setcode do
      Facter.value :cron_name
    end
end

Facter.add(:poweruser_grp) do
  setcode do
    username = Facter.value('poweruser_name')
    #{}"'boh': username=#{username}"
    case Facter.value('operatingsystem')
       when "Darwin"
         'staff'
       else
         'riccardo_else'
    end
  end
end

# See: http://docs.puppetlabs.com/guides/custom_facts.html
Facter.add(:poweruser_group) do
  setcode do
    return File.stat(Facter.value(:poweruser_home)).gid # rescue Facter.value(:poweruser_name)
    sample_file = File.expand_path(Facter.value(:poweruser_home) + "/.bashrc")
    if File.exist?(sample_file)
      arr_ls = Facter::Util::Resolution.exec("/bin/ls -al '#{sample_file}'").chomp.split rescue nil
      if (arr_ls.kind_of?(Array)) 
        arr_ls[3]
      end
      # otherwise it should return nil and the other definition should yield! :)
      #ls -al ~riccardo/.bashrc | awk '{print $4}'
    else
      Facter.value(:poweruser_name)
    end
  end
end

Facter.add('poweruser_simplegroup') do
 setcode do
  username = Facter.value(:poweruser_name) || 'dunno_simplegroup'
  #username ||= $dflt_poweruser_name
  os = Facter.value('operatingsystem')
    case os
      when "RedHat", "CentOS", "SuSE", "Fedora"
        #system "ls -al /home/#{username}/.bashrc | awk '{print $4}'"
        return username
      when "Debian", 'Ubuntu'
        return username # in ubuntu its the same!
      when "Darwin"
        return 'staff' # 
      else
        return "Unknown OS: '#{os}'"
    end
 end
end
# just a dynamism test :)
#Facter.add("#{my_power_user}_home") do
#    setcode do
#      `echo ~#{my_power_user}`
#    end
#end

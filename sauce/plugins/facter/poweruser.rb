
# Poweruser defined in the cluster, i.e.:
# $power_user  = 'riccardo'

# $power_user defined in the cluster!
$dflt_poweruser_name = 'riccardo' # on my CYGWIN im 'riccardo_carlesso'

# minor weight. See here:
# http://docs.puppetlabs.com/guides/custom_facts.html
Facter.add(:poweruser_group) do
  has_weight 100 # high
  return File.stat(Facter.value(:poweruser_home)).gid # rescue Facter.value(:poweruser_name)
  sample_file = File.expand_path(Facter.value(:poweruser_home) + "/.bashrc")
  setcode do
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

# on Mac it's 'staff'. On Ubuntu/Debian it equals the username
Facter.add(:poweruser_group) do
  has_weight 50 # Low
  setcode do
    :staff
  end
end

Facter.add(:poweruser_group2) do
  username = Facter.value('poweruser_name')
  os = Facter.value('operatingsystem')
    case os
      when "RedHat", "CentOS", "SuSE", "Fedora"
        system "ls -al /home/#{username}/.bashrc | awk '{print $4}'"
      when "Debian", "Ubuntu"
        username # in ubuntu its the same!
      when "Darwin"
        'staff' # 
      else
    end
end

# HOME of poweruser
Facter.add(:poweruser_home) do
    setcode do
      # there must be a better way
      File.expand_path("~" + Facter.value(:poweruser_name) )
    end
end

Facter.add(:poweruser_exists) do
    setcode do
      File.exists?(File.expand_path(Facter.value(:poweruser_name)))
    end
end

Facter.add(:poweruser_name) do
    setcode do
      Facter.value(:cluster_poweruser_name) || $dflt_poweruser_name
    end
end

Facter.add(:poweruser_email) do
    setcode do
      Facter.value :cron_name
    end
end

# My personal playground

# $power_user defined in the cluster!
#$dflt_power_user = 'riccardo' # on my CYGWIN im 'riccardo_carlesso'

Facter.add(:sauce_custom_facts) do
    setcode do
      #TODO Add: sauce_custom_facts, "#{power_user}_home"
      %w{ultimate_answer  richome poweruser_home poweruser_exists roothome}
    end
end

Facter.add(:ultimate_answer) do
    setcode do
      42
    end
end

Facter.add(:richome) do
    setcode do
        ENV['HOME'] + ' (plugins facter)'
    end
end

Facter.add(:poweruser_exists) do
    setcode do
      File.exists?(power_user)
      # If USer.exists?('riccardo')
        #ENV['HOME']
    end
end

# dflt name
Facter.add(:poweruser_home) do
    setcode do
      # there must be a better way
      Facter::Util::Resolution.exec("echo ~#{power_user}").chomp
    end
end

Facter.add("#{power_user}_home") do
    setcode do
      `echo ~#{power_user}`
    end
end

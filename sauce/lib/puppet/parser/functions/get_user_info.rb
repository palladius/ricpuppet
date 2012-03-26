
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

module Puppet::Parser::Functions
    newfunction(:get_home, :type => :rvalue) do |args|
        username = args[0].to_s || 'dunno'
        home =File.expand_path("~" + username)
        throw "Home not found for user '#{username}': aborting" unless File.exists?(home)
        home
    end
end
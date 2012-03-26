module Puppet::Parser::Functions
  newfunction(:get_home, :type => :rvalue) do |args|
      username = lookupvar('poweruser_name').to_s
      home =File.expand_path("~" + username)
      throw "Home not found for user '#{username}': aborting" unless File.exists?(home)
      home
  end
end
require 'facter'

Facter.add("home") do
    setcode do
        ENV['HOME']
    end
end

Facter.add("richome") do
    setcode do
        ENV['HOME'] + " (lib)"
    end
end

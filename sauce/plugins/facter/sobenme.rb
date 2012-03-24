Facter.add(:richome) do
    setcode do
        ENV['HOME'] + ' (plugins facter)'
    end
end

Facter.add("home") do
    setcode do
        ENV['HOME']
    end
end
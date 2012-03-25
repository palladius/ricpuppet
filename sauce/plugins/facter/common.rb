# Serious stuff that anybody might want to 'steal'


# Home of current user, which should ALWAYS be root.
Facter.add("roothome") do
    setcode do
        ENV['HOME']
    end
end

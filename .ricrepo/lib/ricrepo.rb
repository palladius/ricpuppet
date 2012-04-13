
# Tutorial from: http://www.kartar.net/2010/02/puppet-types-and-providers-are-easy/

Puppet::Type.newtype(:ricrepo) do
    @doc = "Manage riccardo repos => Ric extend this mirabolant docs"

    ensurable

    newparam(:source) do
        desc "The repo source"

        validate do |value|
            if value =~ /^git/
                resource[:provider] = :git
            else
    #            resource[:provider] = :svn
							throw "Sorry I not speak puppet, me known't this format: '#{value}'"
            end
        end
        isnamevar
    end

    newparam(:path) do
        desc "Destination path"

        validate do |value|
            unless value =~ /^\/[a-z0-9]+/
                raise ArgumentError , "%s is not a valid file path" % value
            end
        end
    end
end

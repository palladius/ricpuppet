
# locate git/ricpuppet/VERSION
# Facter.add("ricpuppet_version") do
#     setcode do
#         '4.5.6TODO'
#     end
# end
# 
# Facter.add("sauce_version") do
#     setcode do
#         '1.2.3TODO'
#     end
# end

Facter.add("pwd") do
    setcode do
        `pwd`
    end
end

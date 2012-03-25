# My personal playground


Facter.add(:sauce_custom_facts) do
    setcode do
      #TODO Add: sauce_custom_facts, "#{power_user}_home"
      %w{ultimate_answer richome poweruser_home poweruser_exists roothome}.join(', ')
    end
end

Facter.add(:ultimate_answer) do
    setcode do
      42
    end
end

# test
Facter.add(:richome) do
    setcode do
        ENV['HOME']
    end
end


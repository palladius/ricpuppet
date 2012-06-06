# Virtualization stuff


# tests if its a gc instance
Facter.add(:gcompute_instance) do
  setcode do
    `sudo grep Google /sys/firmware/dmi/entries/1-0/raw >/dev/null && echo true || echo false`
  end
end


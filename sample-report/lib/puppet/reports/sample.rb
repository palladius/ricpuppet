
require 'puppet'
require 'yaml'
require 'logger'


LOG = Logger.new('/tmp/riccardo-puppet.log')

Puppet::Reports.register_report(:sample) do
	def process
		message = "Puppet run Riccardo test for #{self.host} #{self.status}"
		Puppet.debug "Hello from sample report processor by Riccardo"
		LOG.info message
  end
end


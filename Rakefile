require 'rake'

begin
  require 'rspec/core/rake_task'             # for rspec
  require 'puppet-lint/tasks/puppet-lint'    # should also test lint-ness
rescue LoadError
  require 'rubygems'
  retry
end

# changed to '_spec/' so it doesnt look like puppet modules..
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = '_spec/*/*_spec.rb'
end

task :test => [:spec, :lint]

task :default => :test

require 'rake'
require 'rspec/core/rake_task'

desc "Run all specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern ='spec/**/*.rb'
  t.rspec_opts = ['-I lib', '--color']
end

task :default => :spec

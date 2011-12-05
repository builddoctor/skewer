require 'rake'
require 'rspec/core/rake_task'

desc "Run all specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern ='spec/**/*.rb'
  t.rspec_opts = ['-I lib', '--color']
  t.rcov = true
  t.rcov_opts = %w{--include lib --include lib/ersatz --exclude osx\/objc,gems\/,spec\/,features\/}
  
end

task :default => :spec

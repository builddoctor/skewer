require 'rubygems'

require 'rake'
require 'rspec/core/rake_task'
require 'rake/clean'
require 'metric_fu'

CLEAN.include('coverage')
CLEAN.include('target')
CLEAN.include('/tmp/skewer_test_codez')
 MetricFu::Configuration.run do |config|
        #define which metrics you want to use
        config.metrics  = [:saikuro, :flog, :flay, :reek, :roodi, :rcov]
        #config.graphs   = [:flog, :flay, :stats]
        config.rcov[:test_files] = ['spec/**/*_spec.rb']
        config.rcov[:rcov_opts] << "-Ispec" # Needed to find spec_helper
    end


desc "Run all specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern ='spec/**/*.rb'
  t.rspec_opts = ['-I lib', '--color']
end

require 'vagrant'

desc "fire up vagrant so we can test the plain ssh update script"
task :bumsrush do 
  env = Vagrant::Environment.new
  env.cli("destroy")
end

task :vagrant do 
  env = Vagrant::Environment.new
  env.cli("up")
end

require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end




task :default => [:clean, :spec, :features]
task :features => :vagrant
task :clean => :bumsrush

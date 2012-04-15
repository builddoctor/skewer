# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "skewer/version"

Gem::Specification.new do |s|
  s.name        = "skewer"
  s.version     = Skewer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Julian Simpson", "Kushal Pisavadia"]
  s.email       = ["julian@build-doctor.com"]
  s.homepage    = "http://www.build-doctor.com/skewer"
  s.summary     = "skewer-#{s.version}"
  s.description = "Runs masterless puppet code on cloud machines"

  s.rubyforge_project = "skewer"

  s.add_runtime_dependency 'fog', '~> 1.1.2'

  s.add_development_dependency 'aruba'
  s.add_development_dependency 'jeweler'
  s.add_development_dependency 'metric_fu'
  s.add_development_dependency 'rcov', '~> 1.0.0'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vagrant'

  s.files         = `git ls-files`.split("\n").reject {|path| path =~ /\.gitignore$/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

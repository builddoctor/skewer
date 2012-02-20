# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "skewer/version"

Gem::Specification.new do |s|
  s.name        = "skewer"
  s.version     = Skewer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = "skewer-#{s.version}"
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "skewer"

  s.add_runtime_dependency 'fog', '~> 1.1.2'
  #s.add_runtime_dependency 'json'

  s.add_development_dependency 'jeweler'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'metric_fu'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'vagrant', '~> 0.9.0'

  s.files         = `git ls-files`.split("\n").reject {|path| path =~ /\.gitignore$/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

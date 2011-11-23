#!/usr/bin/env ruby
require 'rubygems'
require 'fog'

require 'node'
require 'aws'
require 'puppet'

@start_time = Time.now

def timestamp(message)
  puts "#{message} at #{Time.now - @start_time}"
end

def copy_source_code(node)
  excludes = ''
  excludes << "--exclude=.git"
  node.ssh 'mkdir -p infrastructure'
  timestamp "About to rsync"
  `rsync #{excludes} --delete -apze ssh . #{node.username}@#{node.dns_name}:infrastructure/.`
  timestamp "Rsync done"
end

def copy_and_execute(node, file) 
  if File.exists?(file)
    `scp #{file} #{node.username}@#{node.dns_name}:/var/tmp/.`
    node.ssh "sudo bash /var/tmp/#{File.basename(file)}"
  end
end

def bootstrap_puppet_module(node, mod)  
  timestamp "bootstrapping #{mod}"
  copy_and_execute(node, "etc/puppet/modules/#{mod}/bootstrapper.sh")
  timestamp "bootstrapped #{mod}"
end

def install_gems(node)
  timestamp "installing rubygems"
  puts node.ssh '. /etc/profile.d/rubygems.sh  && cd infrastructure && bundle install'
  timestamp "done"

end

def bootstrap(node, modules)
  timestamp 'bootstrapping'
  timestamp 'setting the ssh hostkey'
  `ssh -o 'StrictHostKeyChecking no' -o 'PasswordAuthentication no' foo@#{node.dns_name} >/dev/null 2>&1`
  timestamp 'copying the code over'
  copy_source_code(node)
  modules.each {|m| bootstrap_puppet_module(node, m) }
  install_gems(node)
  timestamp 'bootstrapped'
end

def create_local_node
  compute = Fog::Compute.new({
    :provider => 'AWS',
    :endpoint => 'http://localhost:4567'
  })
  node = compute.servers.bootstrap()
end

def test_node(node)
  # TODO: call cukes
end

def run_puppet(node, options)
  timestamp 'gonna puppet'
  result = Puppet.run(node, options)
  raise "Puppet failed" unless result.status == 0 
  timestamp "Puppet done"
end

def destroy_node(node, options)
  node.destroy unless options[:keep]
end

def build_node(node, options)
  begin
    node.wait_for { ready? }
    @dns_name = node.dns_name
    @username = '#{node.username}'

    timestamp "Node ready"
    bootstrap(node, ['rubygems', options[:role]])
    run_puppet(node, options)

    puts "Node ready\n open http://#{@dns_name} or \n ssh -l ubuntu #{@dns_name}"
  rescue Exception => e
  destroy_node(node, {})
    puts e
  end
destroy_node(node, options)
end


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
  # methinks you belong in a bootstrapper class
  require 'source'
  Source.new('../infrastructure').rsync(node)
end

def bootstrap(node, modules)
  require 'bootstrapper'
  timestamp 'bootstrapping'
  bootstrapper = Bootstrapper.new(node)
  bootstrapper.add_ssh_hostkey
  bootstrapper.execute('rubygems.sh')
  copy_source_code
  bootstrapper.install_gems
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


#!/usr/bin/env ruby
require 'rubygems'
require 'fog'

require 'node'
require 'aws'

@start_time = Time.now

def timestamp(message)
  puts "#{message} at #{Time.now - @start_time}"
end

def bootstrap(node, options)
  require 'bootstrapper'
  timestamp 'bootstrapping'
  bootstrapper = Bootstrapper.new(node)
  bootstrapper.add_ssh_hostkey
  bootstrapper.execute('rubygems.sh')
  bootstrapper.sync_source
  bootstrapper.install_gems
  timestamp 'bootstrapped'
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
    bootstrap(node, options)
    timestamp 'gonna puppet'
    result = Puppet.run(node, options)
    timestamp "Puppet done"

    puts "Node ready\n open http://#{@dns_name} or \n ssh -l ubuntu #{@dns_name}"
  rescue Exception => e
  destroy_node(node, {})
    puts e
  end
destroy_node(node, options)
end


require 'config'

module Skewer
  # puts all of puppet's dependencies on
  class Bootstrapper
    def initialize(node,options)
      @node = node
      @options = options
    end

    def add_ssh_hostkey
      system "ssh -o 'StrictHostKeyChecking no' -o 'PasswordAuthentication no' no_such_user@#{@node.dns_name} >/dev/null 2>&1"
    end

    def execute(file_name)
      file = File.join(File.dirname(__FILE__), '..', 'assets', file_name)
      raise "#{file} does not exist" unless File.exists? file
      @node.scp file, '/var/tmp/.'
      result = @node.ssh "sudo bash /var/tmp/#{file_name}"
      puts result[0].stdout
      puts result[0].stderr
      puts result.inspect
      # what if it fails?
    end

    def install_gems
      puts "Installing Gems"
      @node.scp 'assets/Gemfile', 'infrastructure'
      command = ". /etc/profile.d/rubygems.sh && cd infrastructure && bundle install"
      puts @node.ssh(command)[0].stdout
      puts @node.ssh(command)[0].stderr
      # what if it fails?
    end

    def add_key_to_agent(executor = Kernel, homedir = ENV['HOME'])
      config = SkewerConfig.instance
      key_name = config.get('key_name')
      key_path = File.join(homedir, '.ssh', "#{key_name}.pem")
      puts "****Looking for #{key_path}"
      if File.exists?(key_path)
        puts "Adding #{key_path}"
        executor.system("ssh-add #{key_path}")
      end
    end

    def sync_source()
      require 'source'
      require 'puppet_node'
      config = SkewerConfig.instance
      source_dir = config.get(:puppet_repo)
      puts "Using Puppet Code from #{source_dir}"
      role = @options[:role]
      if role
        PuppetNode.new({:default => role.to_sym}).render
      end
      # TODO: if there's no role, it should look it up from an external source
      Source.new(source_dir).rsync(@node)
    end

    def go
      add_ssh_hostkey
      execute('rubygems.sh')
      add_key_to_agent
      sync_source
      install_gems
    end
  end
end

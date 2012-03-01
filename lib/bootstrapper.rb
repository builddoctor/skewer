require 'config'
require 'util'

module Skewer
  # puts all of puppet's dependencies on
  class Bootstrapper
    MAX_CACHE = 3600
    attr_writer :mock
    def initialize(node,options)
      @node = node
      @options = options
      @util = Util.new
      @mock = false
    end

    def add_ssh_hostkey
      location = @util.get_location(@node)
      system "ssh -o 'StrictHostKeyChecking no' -o 'PasswordAuthentication no' no_such_user@#{location} >/dev/null 2>&1"
    end

    def execute(file_name)
      file = File.join(File.dirname(__FILE__), '..', 'assets', file_name)
      raise "#{file} does not exist" unless File.exists? file
      @node.scp file, '/var/tmp/.'
      result = @node.ssh "sudo bash /var/tmp/#{file_name}"
      puts result.inspect
      # what if it fails?
      return result
    end

    def install_gems
      puts "Installing Gems"
      @node.scp 'assets/Gemfile', 'infrastructure'
      command = ". /etc/profile.d/rubygems.sh && cd infrastructure && bundle install"
      result = @node.ssh(command)
      puts result.inspect
      return result
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
      if @mock
        puts "Mock: would normally rsync now"
      else
        Source.new(source_dir).rsync(@node)
      end

    end

    def lock_file
      puts "DEBUG:"
      puts Util.new.get_location(@node)
      puts "DEBUG"
      File.join('/tmp', 'skewer-' + Util.new.get_location(@node))
    end

    def lock_file_expired?(lock_file)
      now = Time.now
      lock_file_time = File.stat(lock_file).mtime
      puts now
      puts lock_file_time
      age = now - lock_file_time
      puts age
      age > MAX_CACHE
    end

    def destroy_lock_file()
      FileUtils.rm_f(self.lock_file)
    end

    def should_i_run?
      lock_file = lock_file()
      puts lock_file
      if File.exists?(lock_file)
        if lock_file_expired?(lock_file)
          destroy_lock_file
          return true
        else
          return false
        end
      else
        FileUtils.touch(lock_file)
        return true
      end
    end

    def prepare_node
      add_ssh_hostkey
      execute('rubygems.sh')
      add_key_to_agent
    end

    def go
      i_should_run = should_i_run?
      prepare_node() if i_should_run
      sync_source
      install_gems if i_should_run
    end
  end
end

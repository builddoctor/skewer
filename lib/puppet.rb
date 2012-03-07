module Skewer
  require 'puppet_runtime_error'
  # responsible for executing puppet
  class Puppet
    def arguments
      [
       "--modulepath modules",
       "--vardir /var/lib/puppet"
      ].join(' ')
    end

    def bundle
      "/var/lib/gems/1.8/bin/bundle"
    end

    def command_string(username, options)
      @command_line = "cd infrastructure"
      if username == 'root'
        @command_line << " &&"
      else
        @command_line <<  " && sudo"
      end
      @command_line << " #{self.bundle} exec"
      @command_line << " puppet apply"
      @command_line << " manifests/site.pp"
      @command_line << " --color false"
      @command_line << " #{arguments}"
      if options[:noop]
        @command_line << " --noop"
      end
      @command_line
    end

    def run(node, options)
      command = command_string(node.username, options)
      result = node.ssh(command)[0]
      if result.status != 0
        puts result.stdout
        raise PuppetRuntimeError, "Puppet failed"
      else
        puts "Puppet run succeeded"
      end
      result
    end

    def self.run(node, options)
      this =  self.new
      this.run(node, options)
    end
  end
end

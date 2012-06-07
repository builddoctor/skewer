require 'skewer'
require 'skewer/strategy/bundler'

module Skewer
  # responsible for executing puppet
  class Puppet
    include Skewer

    def initialize(installer)
      @installer = installer
    end

    def arguments
      [
       "--modulepath modules",
       "--vardir /var/lib/puppet"
      ].join(' ')
    end

    def command_string(username, options)
      @command_line = "cd infrastructure"
      if username == 'root'
        @command_line << " &&"
      else
        @command_line <<  " && sudo"
      end
      @command_line << " #{@installer.executable}"
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
        logger.debug result.stdout
        raise  "Puppet failed"
      else
        logger.info "Puppet run succeeded"
      end
      result
    end

    def self.run(node, installer, options)
      this = self.new(installer)
      this.run(node, options)
    end
  end
end
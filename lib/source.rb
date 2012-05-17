require 'util'

module Skewer
  # responsible for moving source to remote nodes
  class Source
    include Skewer
    def initialize(path = nil)
      #@util = Util.new
      raise "I can't see the path #{path}" unless File.exists?(path)
      @path = path.sub(/\/$/, '')
      @logger = Skewer.logger
    end

    def excludes
      '--exclude Gemfile --exclude Gemfile.lock --exclude ' + ['.git'].join(' ')
    end

    def create_destination(node)
      begin
        node.ssh('mkdir -p infrastructure')
      rescue
        location = get_location(node)
        raise "Couldn't SSH to #{location} with #{node.username}"
      end
    end

    def rsync_command(node)
      location = get_location(node)
      "rsync #{self.excludes} --delete -arpze ssh #{@path}/. #{node.username}@#{location}:infrastructure/."
    end

    def mock_rsync(command)
      @logger.debug "MOCK: #{command}"
    end

    def real_rsync(node, command)
      location = get_location(node)
      raise "Failed to rsync to #{location} with #{node.username}" unless system(command)
    end

    def rsync(node)
      location = get_location(node)
      @logger.debug "Copying code to #{location} ..."
      create_destination(node)
      command = self.rsync_command(node)
      node.class.to_s =~ /StubNode/ ? mock_rsync(command) : real_rsync(node, command)
      @logger.debug " Done."
    end
  end
end

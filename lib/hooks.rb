module Skewer
  require 'config'
  require 'logger'
  class Hooks

    attr_writer :command
    def initialize(host_name)
      @command = SkewerConfig.instance.get('hook')
      @host_name = host_name
      @logger = Logger.new(STDOUT)
    end

    def run
      return_code = false
      unless @command.nil?
        @logger.debug "Running hooks ..."
        `#{@command}  #{@host_name}`
        return_code = $? == 0 ? true : false
      end
      return_code
    end
  end
end

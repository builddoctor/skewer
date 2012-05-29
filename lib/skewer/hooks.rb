module Skewer
  require 'skewer/config'

  # responsible for calling post-run hooks
  class Hooks
    include Skewer

    attr_writer :command

    def initialize(host_name)
      @command = config.get(:hook)
      @host_name = host_name
    end

    def run
      return_code = false
      unless @command.nil?
        logger.debug "Running hooks ..."
        `#{@command}  #{@host_name}`
        return_code = $? == 0 ? true : false
      end
      return_code
    end
  end
end

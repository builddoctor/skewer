require 'logger'

module Skewer
  # fakes a fog SSH result
  class ErsatzSSHResult
    attr_accessor :command, :stdout, :status
    def initialize(command, stdout, status)
      @command = command
      @stdout = stdout
      @status = status
      @logger = Logger.new(STDOUT)
      @logger.debug self.stdout
    end
  end
end

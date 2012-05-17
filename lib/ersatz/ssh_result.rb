require 'skewer'

module Skewer
  # fakes a fog SSH result
  class ErsatzSSHResult
    include Skewer
    attr_accessor :command, :stdout, :status

    def initialize(command, stdout, status)
      @command = command
      @stdout = stdout
      @status = status
      logger.debug stdout
    end
  end
end

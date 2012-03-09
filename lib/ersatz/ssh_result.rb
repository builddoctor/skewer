module Skewer
  # fakes a fog SSH result
  class ErsatzSSHResult
    include Logging
    attr_accessor :command, :stdout, :status

    def initialize(command, stdout, status)
      @command = command
      @stdout = stdout
      @status = status
      logger.debug self.stdout
    end
  end
end

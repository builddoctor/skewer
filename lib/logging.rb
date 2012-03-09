module Skewer
  require 'logger'

  module Logging
    def logger
      Logging.logger
    end

    # Global, memoized, lazy initialised instance of a logger.
    def self.logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end

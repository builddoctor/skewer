module Skewer
  require 'logger'

  class << self
    def logger
      return @log if @log
      @log = Logger.new(STDOUT)
    end

    def logger=(logger)
      @log = logger
    end
  end
end

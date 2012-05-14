module Skewer
  class SkewerCommand
    require 'config'
    attr_reader :config

    def initialize(global, local)
      #puts Command.inspect
      @config = SkewerConfig.instance
      @config.slurp_options(global  )
      @config.slurp_options(local  )
    end
  end
end
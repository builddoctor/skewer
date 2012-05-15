module Skewer
  class SkewerCommand
    require 'config'
    attr_reader :config

    def initialize(global, local)
      @config = SkewerConfig.instance
      @config.slurp_options(global  )
      @config.slurp_options(local  )
    end

    def is_option_boolean?(option)
      unless [true, false].include?(@global_options[option])
        return false, "Sorry, that's a bad value of '#{option}''"
      end
    end
  end
end
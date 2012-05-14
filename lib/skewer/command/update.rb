require 'skewer/command'
module Skewer
  module Command
    class Update < Skewer::SkewerCommand
      def initialize(global_options, options)
        @options = options
        @global_options = global_options
      end

      def is_option_boolean?(option)
        unless [true, false].include?(@global_options[option])
          return false, "Sorry, that's a bad value of '#{option}''"
        end
      end


      def valid?
        unless @options[:user] && @options[:role] && @options[:host]
          return false, "Sorry, I need a user, role and host for this command"
        end
        return is_option_boolean?(:mock) if @global_options[:mock]
        return is_option_boolean?(:noop) if @global_options[:noop]
        [true, 'All good here']


      end

      def execute
        validity, message = valid?
        raise message unless validity
        # do something

      end

    end
  end
end

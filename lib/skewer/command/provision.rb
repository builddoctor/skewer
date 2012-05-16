require 'skewer/command'
require 'cli'
module Skewer
  module Command
    #Implements skewer provision
    class Provision < Skewer::SkewerCommand

      def initialize(global_options, options)
        @global_options = global_options
        @options = options
        @universal_options = @options.merge(@global_options)
        puts @universal_options
      end

      def valid?
        return [false, "A key (--key KEY) must be provided if using EC2"] if @options[:cloud] == :ec2 && !@options[:key_name]
        return [false, "I need a cloud, image and role to do this"] unless @options[:cloud] && @options[:image] && @options[:role]
        return is_option_boolean?(:mock) if @global_options[:mock]
        return is_option_boolean?(:noop) if @global_options[:noop]
        return [true, "I'm happy'"]
      end

      def execute
        validity, message = valid?
        raise message unless validity
        Skewer::Dispatcher.bootstrap_and_go(@universal_options)
      end
    end
  end
end
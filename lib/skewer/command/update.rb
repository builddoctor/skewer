require 'skewer/command'
module Skewer
  module Command
    class Update   < Skewer::SkewerCommand
      def initialize(global_options, options)

        raise "Sorry, I need a user, role and host for this command" unless options[:user] && options[:role] && options[:host]
        #raise "Sorry, that's a bad value of 'mock" unless [true, false].include?(global_options[:mock])



      end

      def execute

      end

    end
  end
end
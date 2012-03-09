require 'fog'

module Skewer
  class CLI
    # Parses the CLI input and makes sure that it's clean.
    class Parser
      def initialize(type = nil, options = {})
        # base case tests that we have input that we accept.
        raise usage if type.nil? and options.empty?
        raise usage if type != 'provision' and type != 'update'
        if type == 'provision'
          unless options[:kind] && options[:image] && options[:role]
            raise "Usage: skewer provision --cloud <which cloud>  --image <AWS image> --role <puppet role class>"
          end
        elsif type == 'update'
          unless options[:host] && options[:user] 
            raise "Usage: skewer update --host <host> --user <user with sudo rights> --role <puppet role class>"
          end
        end

        Fog.mock! if options[:mock] == true
        # TODO: Pass this on to Skewer::CLI.bootstrap_and_go(options)
      end

      def usage
        "Usage: skewer provision|update [options]"
      end
    end
  end
end

module Skewer
  class CLI
    # Parses the CLI input and makes sure that it's clean.
    class Parser
      def initialize(type = nil, options = {})
        # base case tests that we have input that we accept.
        raise "#{self.class.name} requires a type and options hash." if type.nil? or options.empty?
        raise "The only types accepted are 'provision' and 'update'\nUsage: skewer provision|update" if type != 'provision' and type != 'update'
        if type == 'provision'
          unless options[:kind] && options[:image] && options[:role]
            raise "Usage: skewer provision --cloud <which cloud>  --image <AWS image> --role <puppet role class>"
          end
        elsif type == 'update'
          unless options[:host] && options[:user] 
            raise "Usage: skewer update --host <host> --user <user with sudo rights> --role <puppet role class>"
          end
        end
      end
    end
  end
end

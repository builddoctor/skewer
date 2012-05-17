require 'skewer/command'
module Skewer
  module Command
    # Implements skewer delete
    class Delete < Skewer::SkewerCommand

      def initialize(global_options, options, args)
        @global_options = global_options
        @options = options
        @args = args
        @host = args[0]
        @cloud = @options[:cloud]
        @region = @options[:region]
      end

      def valid?
        unless @cloud
          return [false, 'I need a cloud to delete a node from']
        end
        unless @args.length == 1
          return [false, 'Wrong number of hosts to delete']
        end
        unless @args[0] =~ /\w+\.\w+/
          return [false, "That doesn't look like a real host to me"]
        end
        [true, 'okay then']

      end

      def execute
        validity, message = valid?
        raise message unless validity

        if @region
          SkewerConfig.set 'region', @region
        end

        find_node().destroy
      end

      def find_node
        case @cloud.to_sym
          when :ec2
            require 'aws/node'
            node = AWS::Node.find_by_name(@host)
          when :rackspace
            node = Rackspace::Node.find_by_ip(@host)
          else
            raise("I don't know about cloud '#{@cloud}''")
        end
        node
      end
    end
  end
end

require 'skewer'
require 'aws/service'

module Skewer
  module AWS
    # Build out an AWS node using Fog.
    class Node
      include Skewer
      attr_reader :node

      def initialize(aws_id, group_names, options = {})
        if options[:aws_node]
          @node = options[:aws_node]
        else
          @service = self.class.find_service(options)
          node_options = {
              :image_id   => aws_id,
              :flavor_id  => config.get(:flavor_id),
              :username   => config.get(:aws_username),
              :groups     => group_names
          }

          node_options[:key_name] = options[:key_name] if options[:key_name]

          node_options[:key_name] = config.get(:key_name) if config.get(:key_name)

          @node = @service.servers.bootstrap(node_options)
        end
      end

      def self.find_service(options)
        options[:service] ? options[:service] : AWS::Service.new.service
      end

      def destroy
        @node.destroy
      end

      def self.find_by_name(dns_name, service = self.find_service({}))
        node = service.servers.select { |server| server.dns_name == dns_name }[0]
        if node
          return self.new(nil, nil, {:aws_node => node})
        else
          return false
        end
      end
    end
  end
end

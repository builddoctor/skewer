require 'skewer'
require 'aws/service'

module Skewer
  # Build out an AWS node using Fog.
  class AwsNode
    attr_reader :node

    def initialize(aws_id, group_names, options = {})

      if options[:aws_node]
        @node = options[:aws_node]
      else
        @service = self.class.find_service(options)
        node_options = {
            :image_id => aws_id,
            :flavor_id => SkewerConfig.get('flavor_id'),
            :username => SkewerConfig.get('aws_username'),
            :groups => group_names

        }

        if options[:key_name]
          node_options[:key_name] = options[:key_name]
        end

        if SkewerConfig.instance.get('key_name')
          node_options[:key_name] = SkewerConfig.get('key_name')
        end

        @node = @service.servers.bootstrap(node_options)
      end
    end

    def self.find_service(options)
      options[:service] ? options[:service] : AwsService.new.service
    end

    def destroy
      @node.destroy
    end

    def self.find_by_name(dns_name, service = self.find_service({}))
      node = service.servers.select { |server| server.dns_name == dns_name }[0]
      if node.respond_to?(:dns_name)
        return self.new(nil, nil, {:aws_node => node})
      else
        return false
      end

    end

  end
end

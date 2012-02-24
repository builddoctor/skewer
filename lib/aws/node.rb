module Skewer
  class AwsNode
    attr_reader :node
    def initialize(aws_id, group_names, options = {})
      @service = AwsService.new.service
      node_options = {
          :image_id => aws_id,
          :flavor_id => SkewerConfig.get('flavor_id'),
          :username => SkewerConfig.get('aws_username'),
          :groups => group_names
          #:key_name => SkewerConfig.get('key_name')
      }
      if options[:key_name]
        node_options[:key_name] = options[:key_name]
      end

      if SkewerConfig.get('key_name')
         node_options[:key_name] = SkewerConfig.get('key_name')

      end

      @node = @service.servers.bootstrap(node_options)
    end
  end
end

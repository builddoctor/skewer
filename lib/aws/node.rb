module Skewer
  class AwsNode
    attr_reader :node
    def initialize(aws_id, group_names, options = {})
      @service = AwsService.new.service
      node_options = {
          :image_id => aws_id,
          :flavor_id => Config.get('flavor_id'),
          :username => Config.get('aws_username'),
          :groups => group_names,
          :key_name => Config.get('key_name')
      }
      key_name = options[:key_name]
      node_options[:key_name] = key_name if key_name
      @node = @service.servers.bootstrap(node_options)
    end
  end
end

module Skewer
  class AwsNode
    def initialize(aws_id, tier, group_names, options = {})
      @service = AwsService.new.service
      node_options = {
          :image_id => aws_id,
          :flavor_id => Config.get('flavor_id'),
          :username => Config.get('aws_username'),
          :groups => group_names
      }
      key_name = options[:key_name]
      node_options[:key_name] = key_name if key_name
      @service.servers.bootstrap(node_options)
    end
  end
end

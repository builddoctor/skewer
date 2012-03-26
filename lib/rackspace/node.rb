require 'fog'
require 'rackspace/images'

module Skewer
  module Rackspace
    # Build out a Rackspace node using Fog.
    class Node
      attr_reader :node

      # By default, boot an Ubuntu 10.04 LTS (lucid) server.
      def initialize(flavor = 1, image = 112, name = 'my_server', instance = nil)
        connection = self.class.find_service

        # Get our SSH key to attach it to the server.
        if instance
          @node = instance
        else
          @node = build(connection, flavor, image, name)
        end
      end

      def self.find_service(region = :usa)
        region = region == :usa ? "auth.api.rackspacecloud.com" : "lon.auth.api.rackspacecloud.com"
        Fog::Compute.new(
          :provider => 'Rackspace',
          :rackspace_api_key => Fog.credentials[:rackspace_api_key],
          :rackspace_username => Fog.credentials[:rackspace_username],
          :rackspace_auth_url => region)
      end

      def build(connection, flavor, image, name)
        path = File.expand_path '~/.ssh/id_rsa.pub'
        path = File.expand_path '~/.ssh/id_dsa.pub' if not File.exist? path
        raise "Couldn't find a public key" if not File.exist? path
        key = File.open(path, 'rb').read

        images = Rackspace::Images.new
        options = {
          :flavor_id  => flavor,
          :image_id   => images.get_id(image),
          :name       => name,
          :public_key => key
        }
        connection.servers.bootstrap(options)
      end

      def destroy
        @node.destroy if !@node.nil?
      end

      def self.find_by_ip(ip_address, service = self.find_service())
        node = service.servers.select { |server| server.public_ip_address == ip_address }
        if node.size > 0
          return self.new(nil, nil, nil, node[0])
        else
          return false
        end
      end
    end
  end
end

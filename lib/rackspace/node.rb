require 'fog'
require 'rackspace/images'
require 'rackspace/service'
require 'config'

module Skewer
  module Rackspace
    # Build out a Rackspace node using Fog.
    class Node
      attr_reader :node

      # By default, boot an Ubuntu 10.04 LTS (lucid) server.
      def initialize(flavor = 1, image = 112, name = 'my_server', instance = nil)
        region = SkewerConfig.get('region')
        connection = self.class.find_service(region)

        # Get our SSH key to attach it to the server.
        instance ? @node = instance : @node = build(connection, flavor, image, name)
      end

      def self.find_service(short_region = 'usa')
        Skewer::Rackspace::Service.new(short_region).build
      end

      def build(connection, flavor, image, name)
        key = find_key()

        images = Skewer::Rackspace::Images.new
        image_id = images.get_id(image)
        options = {
          :flavor_id  => flavor,
          :image_id   => image_id,
          :name       => name,
          :public_key => key
        }
        begin
          connection.servers.bootstrap(options)
        rescue Fog::Compute::Rackspace::NotFound
          raise "Sorry, it looks like there's no such Image Id as #{image_id}"
        end
      end

      def find_key
        ssh_key = nil
        ['id_rsa.pub', 'id_dsa.pub', "#{SkewerConfig.instance.get(:key_name)}.pub"].each do |key|
          key_path =  File.expand_path(File.join(ENV['HOME'],'.ssh', key))
          if File.exist?(key_path)
            ssh_key = key_path
            break
          end
        end

        raise "Couldn't find a public key" unless ssh_key
        File.read(ssh_key)
      end

      def destroy
        @node.destroy unless @node.nil?
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

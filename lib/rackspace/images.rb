module Skewer
  module Rackspace
    # Responsible for locating Rackspace images
    class Images

      attr_reader :distributions

      def initialize
        @distributions = {
          'ubuntu1004' => { :id => 112, :name => "Ubuntu 10.04 LTS"},
          'ubuntu1104' => { :id => 115, :name => "Ubuntu 11.04"},
          'ubuntu1110' => { :id => 119, :name => "Ubuntu 11.10"},
        }
      end

      # If provided a name for an image, give back the ID.
      def get_id(name)
        if name.nil?
          return @distributions['ubuntu1004'][:id]
        end
        name = Integer(name) rescue name

        if name.class == Fixnum
          return name
        end

        unless name.class == String
          return @distributions['ubuntu1004'][:id]
        end

        unless @distributions.has_key?(name)
          raise "An image with the name '#{name}' doesn't exist"
        end
        @distributions[name][:id]
      end
    end
  end
end

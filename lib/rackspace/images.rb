module Skewer
  module Rackspace
    class Images
      attr_reader :supported

      def initialize
        @supported = {
          'ubuntu1004' => { :id => 112, :name => "Ubuntu 10.04 LTS"},
          'ubuntu1104' => { :id => 115, :name => "Ubuntu 11.04"},
          'ubuntu1110' => { :id => 119, :name => "Ubuntu 11.10"},
        }
      end

      # If provided a name for an image, give back the ID.
      def get_id(name)
        return @supported['ubuntu1004'][:id] if name.nil?
        name = Integer(name) rescue name
        return name if name.class == Fixnum
        return @supported['ubuntu1004'][:id] if name.class != String
        raise "An image with the name '#{name}' doesn't exist" if !@supported.has_key?(name)
        @supported[name][:id]
      end
    end
  end
end

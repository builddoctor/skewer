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
    end
  end
end

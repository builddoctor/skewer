module Skewer
  module Rackspace
    class Service
      def initialize(short_region_name)
        @region = region(short_region_name)
      end

      def region(short_region_name = nil)
        short_region_name.to_s == 'lon' ? "lon.auth.api.rackspacecloud.com" :
            "auth.api.rackspacecloud.com"
      end

      def build
        Fog::Compute.new(
            :provider => 'Rackspace',
            :rackspace_api_key => Fog.credentials[:rackspace_api_key],
            :rackspace_username => Fog.credentials[:rackspace_username],
            :rackspace_auth_url => region)
      end

    end
  end
end
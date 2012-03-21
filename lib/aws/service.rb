module Skewer
  module AWS
    # The AWS service which is used to interface through to the AWS
    # cloud using Fog.
    class Service
      attr_reader :service

      def initialize
        region = SkewerConfig.get('region')
        @service = Fog::Compute.new({
          :provider => 'AWS',
          :region => region})
        SkewerConfig.set 'aws_service', @service
      end

      def self.service
        self.new.service
      end
    end
  end
end

module Skewer
  # The AWS service which is used to interface through to the AWS
  # cloud using Fog.
  class AwsService
    attr_reader :service

    def initialize()
      zone = SkewerConfig.get('aws_region')
      @service = Fog::Compute.new({
                                      :provider => 'AWS',
                                      :region => zone
                                  })
      SkewerConfig.set 'aws_service', @service
    end

    def self.service
      self.new.service
    end
  end
end

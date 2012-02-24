module Skewer
  class AwsService
    attr_reader :service

    def initialize()
      zone = SkewerConfig.get('aws_region')
      @service = Fog::Compute.new({
                                      :provider => 'AWS',
                                      :region => zone
                                  })
      SkewerConfig.set 'aws_service', @service
      puts @service.inspect
    end

    def self.service
      self.new.service
    end
  end
end

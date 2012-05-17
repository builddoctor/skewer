module Skewer
  # test stub for pretending to be a real node
  class StubNode
    include Skewer
    attr_reader :dns_name, :username, :public_ip_address

    def initialize
      @dns_name = 'com.doodoo'
      @public_ip_address = '192.168.0.1'
      @username = 'imabirdbrain'
    end

    def announce(return_type)
      logger.debug "#{self.class} will return #{return_type}"
      return_type
    end

    def method_missing(name, *args)
      require 'ersatz/ssh_result.rb'
      logger.debug "#{self.class}.#{name} called with #{args.join(',')}"
      return announce([ErsatzSSHResult.new('foo', 'success', 0)]) if name == :ssh
      announce true
    end
  end
end

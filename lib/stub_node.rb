module Skewer
  # test stub for pretending to be a real node
  class StubNode
    attr_reader :dns_name, :username, :public_ip_address

    def initialize
      @dns_name = 'com.doodoo'
      @public_ip_address = '192.168.0.1'
      @username = 'imabirdbrain'
      @debug = false
    end

    def announce(return_type)
      Skewer.logger.debug "#{self.class} will return #{return_type}" if @debug
      return_type
    end

    def method_missing(name, *args)
      require 'ersatz/ssh_result.rb'
      Skewer.logger.debug "#{self.class}.#{name} called with #{args.join(',')}" if @debug
      return announce([ErsatzSSHResult.new('foo', 'success', 0)]) if name == :ssh
      announce true
    end
  end
end

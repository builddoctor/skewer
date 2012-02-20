module Skewer
  # test stub for pretending to be a real node
  class StubNode
    attr_reader :dns_name, :username
    @dns_name = 'com.doodoo'
    @username = 'imabirdbrain'
    @debug = false

    def announce(return_type)
      puts "#{self.class} will return #{return_type}" if @debug
      return return_type
    end

    def method_missing(name, *args)
      require 'ersatz/ssh_result.rb'
      puts "#{self.class}.#{name} called with #{args.join(',')}" if @debug
      return announce([ErsatzSSHResult.new('foo', 'success', 0)]) if name == :ssh
      return announce true
    end
  end
end

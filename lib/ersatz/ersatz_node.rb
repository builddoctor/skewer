require 'ersatz/ssh_result.rb'

module Skewer
  # fakes a fog node
  class ErsatzNode
    include Skewer
    attr_accessor :username, :dns_name

    def initialize(hostname, user)
      @dns_name = hostname
      @username = user
    end

    def ssh(command)
      full_ssh_command = "ssh -l #{@username} #{@dns_name} '#{command}'"
      logger.debug full_ssh_command
      stdout = `#{full_ssh_command}`
      result = ErsatzSSHResult.new(command, stdout, $?.exitstatus)
      [result]
    end

    def scp(file, dest)
      `scp #{file} #{@username}@#{@dns_name}:#{dest}`
    end

    def destroy
    end

    def wait_for
    end
  end
end

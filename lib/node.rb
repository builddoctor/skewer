module Skewer
  # responsible for talking to remote machines
  class Node
    include Logging
    attr_reader :username

    def initialize
      @address = nil
      @username = nil
      @password = nil
      @pubkey = nil
      @ssh = Fog::SSH::Real.new(
        @address,
        @username,
        {:password => @password}
      )
      install_pubkey(@ssh, @pubkey)
    end

    def install_pubkey(ssh, key)
      key_file = File.read(key).gsub("\n",'')
      ssh(['mkdir -p .ssh', 'chmod 0700 .ssh',"echo #{key_file} > .ssh/authorized_keys"])
    end

    def dns_name
      @address
    end

    def wait_for(*blk)
    end

    def destroy
    end

    def ssh(commands)
      results = @ssh.run(commands)
      if results.is_a?(Array)
        results.each {|result| logger.debug result.stdout }
      else
        logger.debug results.stdout
      end
    end
  end
end

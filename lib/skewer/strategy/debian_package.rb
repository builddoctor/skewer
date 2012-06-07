module Skewer
  module Strategy
    class DebianPackage
      include Skewer
      def initialize(node)
        @node = node
        logger.debug "Deploying Puppet via Debian"
      end

      def install_command
        'sudo aptitude install puppet -y'
      end

      def install
        @node.ssh(self.install_command)

      end

      def executable
        '/usr/bin/puppet'
      end

      def preflight

      end
    end
  end
end

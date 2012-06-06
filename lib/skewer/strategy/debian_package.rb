module Skewer
  module Strategy
    class DebianPackage
      def initialize(node)
        @node = node
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

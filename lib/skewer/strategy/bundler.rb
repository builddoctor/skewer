module Skewer
  module Strategy
    class Bundler
      include Skewer

      def initialize(node)
        @node = node
        @asset_dir = File.join(File.dirname(__FILE__), '..','..', '..', 'assets')
        logger.debug "Deploying Puppet via Bundler"
      end

      def install
        self.install_rubygems
      end

      def executable
        "/usr/local/bin/bundle"
      end

      def execute(file_name)
        file = File.join(@asset_dir, file_name)
        raise "#{file} does not exist" unless File.exists? file
        @node.scp file, '/var/tmp/.'
        result = @node.ssh "sudo bash /var/tmp/#{file_name}"
        logger.debug result.inspect
        result
      end

      def install_rubygems
        execute('rubygems.sh')
      end

      def install_gems
        logger.debug "Installing Gems"


        @node.scp File.join(File.expand_path(@asset_dir), 'Gemfile'), 'infrastructure'
        command = ". /etc/profile.d/rubygems.sh && cd infrastructure && bundle install"
        result = @node.ssh(command)
        logger.debug result
      end

      def preflight
        self.install_gems
      end
    end
  end
end

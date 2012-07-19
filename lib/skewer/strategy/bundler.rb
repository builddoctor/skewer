module Skewer
  module Strategy
    class Bundler
      BUNDLER_PATH = ['/var/lib/gems/1.8/bin/bundle', '/usr/local/bin/bundle', '/usr/bin/bundle']
      include Skewer

      def initialize(node)
        @node = node
        @asset_dir = File.join(File.dirname(__FILE__), '..', '..', '..', 'assets')
        logger.debug "Deploying Puppet via Bundler"
      end

      def install
        self.install_rubygems
      end

      def locate_bundler(bundle = '/usr/local/bin/bundle')
        #TODO: make this work on the remote environment
        #bundles = (BUNDLER_PATH + bundle.to_a)
        #
        #if bundles.length > 0
        #  bundle = bundles.select {| bndl| File.exists?(bndl) }.first
        #end
        #"#{bundle} exec"
        "/usr/local/bin/bundle exec"
      end

      def executable
        locate_bundler()
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

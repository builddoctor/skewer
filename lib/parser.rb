require 'fog'
require 'cli'
require 'aws/node'
require "rackspace/node"

module Skewer
  class CLI
    # Parses the CLI input and makes sure that it's clean.
    class Parser
      def initialize(type = nil, options = {})
        # base case tests that we have input that we accept.
        Fog.mock! if options[:mock] == true
        validate_options(options, type)

        if type == 'delete'
          node = ''
          case options[:kind]
            when :ec2
              node = AwsNode.find_by_name(options[:host])
            when :rackspace
              node = RackspaceNode.find_by_ip(options { :host })
          end
          destroy_node(node, options)
        else
          Skewer::CLI.bootstrap_and_go(options)
        end
      end

      def destroy_node(node, options)
        if node
          node.destroy
          Skewer.logger.info("#{options[:host]} deleted.")
        else
          Skewer.logger.info("#{options[:host]} not found.")
        end
      end

      def validate_options(options, type)
        abort(usage) if type.nil? and options.empty?
        abort(usage) unless ['provision', 'update', 'delete'].include? type
        abort("A key (--key KEY) must be provided if using EC2") if options[:kind] == :ec2 && !options[:key_name]
        if type == 'provision'
          unless options[:kind] && options[:image] && options[:role] && !options[:help]
            abort(provision_usage)
          end
        elsif type == 'update'
          unless options[:host] && options[:user] && !options[:help]
            abort(update_usage)
          end
        elsif type == 'delete'
          unless options[:kind] && options[:host] && !options[:help]
            abort(delete_usage)
          end
        end
      end

      def usage
        out = <<EOF
Usage: skewer COMMAND [options]

The available skewer commands are:
   provision  spawn a new VM via a cloud system and provision it with puppet code
   update     update the puppet code on a machine that you've already provisioned
   delete     deletes the given host from the provided cloud provider
EOF
        out.strip
      end

      def provision_usage
        out = <<EOF
Usage: skewer provision --cloud <which cloud>  --image <AWS image> --role <puppet role class>
EOF
        out.strip
      end

      def update_usage
        out = <<EOF
Usage: skewer update --host <host> --user <user with sudo rights> --role <puppet role class>
EOF
        out.strip
      end

      def delete_usage
        out = <<EOF
Usage: skewer delete --cloud <which cloud> --host <host>
EOF
        out.strip
      end
    end
  end
end

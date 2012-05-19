module Skewer
  module AWS
    # Security group permissions for our AWS service.
    class SecurityGroup
      include Skewer
      attr_reader :service, :group

      def initialize(name, desc, ports)
        @service ||= config.get 'aws_service'
        groups = @service.security_groups
        group = groups.select { |group| group.name == name }[0]

        if group.nil? == true
          group = @service.create_security_group(name, desc)
          group = groups.get(name)
        end
        @group = group

        if ports.length >= 1
          ensure_port_ranges(group, ports)
        end
      end


      def ensure_port_ranges(group, ports)
        ports.each do |port|

          description = port[:description]
          range = port[:range]

          group.revoke_port_range(range)
          group.authorize_port_range(range, {:name => description})
          # TODO: get the port range options in there
        end
      end
    end
  end
end

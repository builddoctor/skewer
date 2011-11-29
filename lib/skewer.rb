class Skewer
  attr_reader :bootstrapper, :node
  def initialize(kind = :ersatz )
    node = select_node(kind)
    @bootstrapper = Bootstrapper.new(node)
    @options = {}
  end

  def select_node(kind)
    # HTF do I choose the node?
    "node"
    case kind
      when :ec2 
        require 'aws'
        puts 'Launching an EC2 node'
        node = AwsNode.new('ami-71589518', nil, ['default'])
        #TODO: fix AwsNode, as it's evil
        #TODO: pass in the AMI as an optionh
      when :linode
        #compute = Fog::Compute.new(@linode_creds)
        #node = compute.servers[0]
        #puts 'Finding an existing linode node'
        raise "not implemented"
      when :eucalyptus
        puts 'Using the EC2 API'
        require 'eucalyptus'
        node = create_local_node
      when :ersatz
        require 'ersatz/ersatz_node'
        node = ErsatzNode.new('localhost', ENV['USERNAME'])
      else
        raise "I don't know that cloud"
    end
    node
  end

end

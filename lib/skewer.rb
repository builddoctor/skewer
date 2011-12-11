require 'bootstrapper'
class Skewer
  attr_reader :bootstrapper, :node
  def initialize(options)
    @options = options
    @config = SkewerConfig.instance
  end

  def select_node(kind)
    puts "Evaluating #{kind}"
    node = ''
    case kind
      when :ec2 
        require 'aws'
        puts 'Launching an EC2 node'
        puts @options.inspect
        group = @options[:group] ? @options[:group] : 'default'
        node = AwsNode.new(@options[:image], nil, ['default'])
        #TODO: fix AwsNode, as it's evil
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
        puts 'Launching a pretend node'
        require 'ersatz/ersatz_node.rb'
        node = ErsatzNode.new('localhost', ENV['USERNAME'])
      when :vagrant
        puts 'Launching a local vagrant node'
        require 'ersatz/ersatz_node.rb'
        node = ErsatzNode.new('default', 'vagrant')
      when :stub
        puts "launching stub one for testing"
        require 'stub_node'
        node = StubNode.new
      else
        raise "I don't know that cloud"
    end
    node
  end

  def destroy
    @node.destroy unless @options[:keep]
  end

  def bootstrap
    node = select_node(@options[:kind])
    @node = node
    @bootstrapper = Bootstrapper.new(node, @options)
    @bootstrapper.go
  end

  def go 
    require 'puppet'
    begin
      @node.wait_for { ready? }
      @bootstrapper.go
      result = Puppet.run(node, @options)

      puts "Node ready\n open http://#{@node.dns_name} or \n ssh -l @node.username #{@node.dns_name}"
    rescue Exception => e
      puts e
      destroy
    end
   destroy
  end

  def self.bootstrap_and_go(options)
    s = self.new(options)
    s.bootstrap
    s.go
  end
end

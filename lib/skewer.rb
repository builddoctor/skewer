require 'bootstrapper'
class Skewer
  attr_reader :bootstrapper, :node
  def initialize(options)
    @options = options
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
        puts 'Launching a pretened node'
        require 'ersatz/ersatz_node'
        node = ErsatzNode.new('localhost', ENV['USERNAME'])
      when :nil
        puts "launching a leetle one for testing"
        node = nil
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
    @bootstrapper = Bootstrapper.new(node)
    @bootstrapper.go
  end

  def go 
    begin
      @node.wait_for { ready? }
      @bootstrapper.go(node, @options)
      result = Puppet.run(node, @options)

      puts "Node ready\n open http://#{@node.dns_name} or \n ssh -l @node.username #{@node.dns_name}"
    rescue Exception => e
      destroy
      puts e
    end
   destroy
  end

end

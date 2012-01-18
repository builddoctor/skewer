class PuppetNode
  attr_accessor :nodes, :puppet_repo
  def initialize(nodes = nil)
    if nodes
      @nodes = nodes
    else
      @nodes = { :default => :noop }
    end
    config = SkewerConfig.instance
    @puppet_repo = config.get(:puppet_repo)
end

  def to_s
    require 'erb'
    lib_dir = File.dirname(__FILE__)
    template = ERB.new(File.read(File.join(lib_dir, 'node.erb')))
    template.result(binding)
  end

  def render
    node_file_path = File.join(@puppet_repo, 'manifests','nodes.pp')
    f = File.new(node_file_path, 'w+')
    f << self.to_s
    f.close
  end


end

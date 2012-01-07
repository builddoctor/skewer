class PuppetNode
  attr_accessor :nodes, :puppet_repo
  def initialize(json = nil)
    @nodes = { :default => :noop }
    config = SkewerConfig.instance
    @puppet_repo = config.get(:puppet_repo)
    if json
      require 'json'
      JSON.parse(json).each_pair do |k,v|
        @nodes[k] = v
      end
    end
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

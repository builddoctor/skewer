class PuppetNode
  attr_accessor :nodes
  def initialize(json = nil)
    @nodes = { :default => :noop }
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
end

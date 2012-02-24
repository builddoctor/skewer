module Skewer
  # responsible for creating a node definition
  class PuppetNode
    attr_accessor :nodes, :puppet_repo

    def initialize(nodes = { :default =>:noop})
      @nodes = nodes
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
      file = File.new(node_file_path, 'w+')
      file << self.to_s
      file.close
    end
  end
end

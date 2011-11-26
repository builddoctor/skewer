class Source
  def initialize(path = nil)
    raise "I can't see the path #{path}" unless File.exists?(path)
    @path = path.sub(/\/$/, '')
  end
  
  def excludes
    '--exclude ' + ['.git'].join(' ')
  end

  def rsync_command(node)
    "rsync #{self.excludes} --delete -apze ssh #{@path}/. #{node.username}@#{node.dns_name}:infrastructure/."
  end

  def rsync(node)
    puts rsync_command(node)
    print "Copying code to #{node.dns_name} ..."

    raise "Failed to rsync to #{node.dns_name} with #{node.username}" unless system self.rsync_command(node)
    puts " Done."
  end
end

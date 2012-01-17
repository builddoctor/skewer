class Source
  def initialize(path = nil)
    raise "I can't see the path #{path}" unless File.exists?(path)
    @path = path.sub(/\/$/, '')
  end
  
  def excludes
    '--exclude ' + ['.git'].join(' ')
  end

  def create_destination(node)
    begin
      node.ssh('mkdir -p infrastructure')
    rescue
      raise "Couldn't SSH to #{node.dns_name} with #{node.username}"
    end
  end

  def rsync_command(node)
    "rsync #{self.excludes} --delete -arpze ssh #{@path}/. #{node.username}@#{node.dns_name}:infrastructure/."
  end

  def mock_rsync(command)
    puts "MOCK: #{command}"
  end

  def real_rsync(node, command)
    raise "Failed to rsync to #{node.dns_name} with #{node.username}" unless system(command)
  end

  def rsync(node)
    puts rsync_command(node)
    print "Copying code to #{node.dns_name} ..."
    create_destination(node)
    command = self.rsync_command(node)

    if node.class.to_s =~ /StubNode/
      mock_rsync(command)
    else
      real_rsync(node, command)
    end
    puts " Done."
  end

end

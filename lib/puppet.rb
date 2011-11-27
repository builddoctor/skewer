class Puppet

  def arguments
    [
      "--modulepath etc/puppet/modules",
      "--node_terminus=exec",
      "--external_nodes=`pwd`/lib/extnode.rb"
    ].join(' ')
  end

  def bundle
    "/var/lib/gems/1.8/bin/bundle"
  end

  def command_string(username, options)
    string = "cd infrastructure"
    if username == 'root'
      string << " &&"
    else
      string <<  " && sudo"
    end
    string << " #{self.bundle} exec"
    string << " puppet apply"
    string << " etc/puppet/manifests/site.pp" 
    if options[:role]
      string << " --certname #{options[:role]}"
    end
    string << " #{arguments}"
    if options[:noop] 
      string << " --noop"
    end
    string
  end

  def run(node, options)
    command = command_string(node.username, options)
    result = node.ssh(command)[0]
    puts "Ran: puppet with: #{result.command}"
    puts "And got status #{result.status}"
    puts "And result #{result.stdout}"
    raise "Puppet failed.  Do you really want to carry on?" if result.status != 0 
    result
  end

  def self.run(node, options)
    s =  self.new
    s.run(node, options)
  end

end

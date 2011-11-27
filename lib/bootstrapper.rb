class Bootstrapper
  def initialize(node)
    @node = node
  end

  def add_ssh_hostkey
    system "ssh -o 'StrictHostKeyChecking no' -o 'PasswordAuthentication no' no_such_user@#{@node.dns_name} >/dev/null 2>&1"
  end

  def execute(file_name)
    file = File.join(File.dirname(__FILE__), '..', 'assets', file_name)
    raise "#{file} does not exist" unless File.exists? file
    @node.scp file, '/var/tmp/.'
    @node.ssh "sudo bash /var/tmp/#{file_name}"

  end

  def install_gems
    command = ". /etc/profile.d/rubygems.sh && cd infrastructure && bundle install"
    @node.ssh command
  end

  def sync_source(source_dir = '../infrastructure') 
    require 'source'
    Source.new('../infrastructure').rsync(@node)
  end


end

class ErsatzNode 
  attr_accessor :username, :dns_name
  def initialize(hostname, user)
    @dns_name = hostname
    @username = user
  end

  def ssh(command)
    full_ssh_command = "ssh  -l #{@username} #{@dns_name} '#{command}'"
    puts full_ssh_command
    stdout = `#{full_ssh_command}`
    result = ErsatzSSHResult.new( command, stdout,  $?.exitstatus)
    [result]
  end

  def scp(file, dest)
    puts "FOOOOOO"
    `scp #{file} #{@username}@#{@dns_name}:#{dest}`
  end


end

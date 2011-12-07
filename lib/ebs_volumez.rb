#TODO implement this properly
def create_ebs_volume(name, node, volume_size)
  service = AwsService.new.service
  volume = service.volumes.new :device => "/dev/#{name}", 
    :size => volume_size,
    :availability_zone => node.availability_zone
  volume.server = node
  volume.save
end

def mount_ebs_volume(node, volume_id)
  puts "Mounting EBS volume #{volume_id} on #{node.id}"
  service = AwsService.new.service
  volume = service.volumes.find(volume_id).first
  volume.device = '/dev/sdj' # for jenkins
  volume.availability_zone = node.availability_zone
  volume.server = node
  volume.save
end

def create_aws_node(options)

  group = AwsSecurityGroup.new('CI', 'Continuous Integration Hosts', [
    { :description => 'SSH', :range => 22..22, :options => {} }])
  node = AwsNode.node('ami-71589518', nil, ['default', options[:group]]).node
  create_ebs_volume('sdn', node, options[:volume]) if options[:volume]
  node
end

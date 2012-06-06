module Skewer
  require 'logger'
  require 'skewer/config'


  def logger
    @log ||= Logger.new(STDOUT)
  end


  # Get the location (dns name, or IP) for a given Fog server. Cloud
  # provider agnostic.
  def get_location(server = nil)
    @has_dns_name = server.respond_to?(:dns_name)
    return nil unless (@has_dns_name or server.respond_to?(:public_ip_address))
    @has_dns_name ? server.dns_name : server.public_ip_address
  end

  def config
    @@config ||= SkewerConfig.new
  end

end

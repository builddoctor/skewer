module Skewer

  # Get the location (dns name, or IP) for a given Fog server. Cloud
  # provider agnostic.
  def get_location(server = nil)
    return nil unless (server.respond_to?(:dns_name) or server.respond_to?(:public_ip_address))
    server.respond_to?(:dns_name) ? server.dns_name : server.public_ip_address
  end

end

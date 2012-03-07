module Skewer
  # A utility class to handle common cloud operations that we'll
  # encounter amongst different providers.
  class Util
    # Get the location (dns name, or IP) for a given Fog server. Cloud
    # provider agnostic.
    def get_location(server = nil)
      # Negative case.
      return nil if server.nil?
      return nil if not server.respond_to?(:dns_name) and not server.respond_to?(:public_ip_address)

      # Positive case.
      return server.dns_name if server.respond_to? :dns_name
      return server.public_ip_address if server.respond_to? :public_ip_address
    end
  end
end

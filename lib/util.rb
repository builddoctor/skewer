module Skewer
  class Util
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

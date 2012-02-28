module Skewer
  class Util
    def get_location(server = nil)
      return nil if server == nil
      return nil if server.respond_to?(:dns_name) == false and server.respond_to?(:public_ip_address) == false

      if server.respond_to? :dns_name
        return server.dns_name
      end

      if server.respond_to? :public_ip_address
        return server.public_ip_address
      end

      return nil
    end
  end
end

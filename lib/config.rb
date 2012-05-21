require 'singleton'
require 'skewer'

module Skewer
  # responsible for all configuration, once I move all the options in
  class SkewerConfig
    include Skewer

    def initialize
      @configs = {}
      reset
      read_config_files

    end

    def reset
      @configs[:puppet_repo] = '../infrastructure'
      @configs[:region] = 'us-east-1'
      @configs[:flavor_id] = 'm1.large'
      @configs[:aws_username] = 'ubuntu'
    end

    def read_config_file(config_file)
      logger.debug "Looking for #{config_file}"
      if File.exists?(config_file)
        logger.debug "Reading #{config_file}"
        config = File.read(config_file)
        parse(config)
      end
    end

    def read_config_files
      read_config_file(File.join(ENV['HOME'], '.skewer.json'))
      read_config_file('.skewer.json')
    end

    def parse(config)
      require 'json'
      configz = JSON.parse(config)
      configz.each do |key,value|
        puts("Setting #{key}, #{value} from config")
        set(key.to_sym, value)
      end
    end

    def set(attribute, value)
      validate_key(attribute)
       @configs[attribute] = value
    end

    def validate_key(attribute)
      unless attribute.class == Symbol
        raise ArgumentError(self.class.to_s + ' now expects a symbol')
      end
    end

    def get(attribute)
      @configs[attribute]
    end


    def translate_key(key)
      key == :puppetcode ?  :puppet_repo :  key
    end

    def slurp_options(options)
      options.each_pair do |key, value|
        self.set(self.translate_key(key), value) unless value.nil?
      end
    end

    def method_missing(sym, *args, &block)
      puts @configs.inspect
      get(sym)
    end
  end
end

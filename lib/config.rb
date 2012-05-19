require 'singleton'
require 'skewer'

module Skewer
  # responsible for all configuration, once I move all the options in
  class SkewerConfig
    include Skewer

    def initialize
      reset
      read_config_files
    end

    def reset
      @puppet_repo = '../infrastructure'
      @region = 'us-east-1'
      @flavor_id = 'm1.large'
      @aws_username = 'ubuntu'
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
        set(key,value)
      end
    end

    def set(attribute, value)
      self.instance_variable_set "@#{attribute}", value
    end

    def get(attribute)
      if attribute.class == Symbol
        attribute = attribute.to_s
      end
      self.instance_variable_get "@" + attribute
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
      get(sym)
    end
  end
end

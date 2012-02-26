require 'singleton'

module Skewer
  # responsible for all configuration, once I move all the options in
  class SkewerConfig
    attr_accessor :aws_service, :puppet_repo, :aws_region, :flavor_id, :aws_username, :flavor_id

    include Singleton

    def initialize

      @puppet_repo = '../infrastructure'
      @aws_region = 'us-east-1'
      @flavor_id = 'm1.large'
      @aws_username = 'ubuntu'

      read_config_files
    end

    def read_config_file(config_file)
      if File.exists?(config_file)
        puts "reading #{config_file}"
        config = File.read(config_file)
        parse(config)
        puts self.inspect
      end
    end

    def read_config_files
      read_config_file(File.join(ENV['HOME'], '.skewer.json'))
      read_config_file('.skewer.json')
    end

    def parse(config)
      require 'json'
      configz = JSON.parse(config)
      configz.each { |key,value| set(key,value) }
    end

    def set(attribute, value)
      self.instance_variable_set "@#{attribute}", value
    end

    def self.set(key,value)
      instance = self.instance
      instance.set(key,value)
    end

    def get(attribute)
      if attribute.class == Symbol
        attribute = attribute.to_s
      end
      self.instance_variable_get "@" + attribute
    end

    def self.get(key)
      self.instance.get(key)
    end
  end
end

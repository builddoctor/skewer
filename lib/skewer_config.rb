require 'singleton'


class SkewerConfig
  attr_accessor :aws_service, :puppet_repo, :aws_region, :flavor_id
  
  include Singleton

  def initialize
    @puppet_repo = '../infrastructure'
    @aws_region = 'us-east-1'
    @flavour_id = 'm1.large'
    read_config_file
  end

  def read_config_file
    config_file =  File.join(ENV['HOME'], '.skewer.json')
    if File.exists?(config_file)
      puts "reading #{config_file}"
      config = File.read(config_file)
      parse(config)
      puts self.inspect
    end
  end

  def parse(config)
    require 'json'
    configz = JSON.parse(config)
    configz.each { |k,v| set(k,v) }
  end

  def set(attribute, value)
    self.instance_variable_set "@#{attribute}", value
  end

  def self.set(a,v)
    i = self.instance
    i.set(a,v)
  end

  def get(attribute)
    if attribute.class == Symbol
      attribute = attribute.to_s
    end
    self.instance_variable_get "@" + attribute
  end

  def self.get(k)
    self.instance.get(k)
  end
end

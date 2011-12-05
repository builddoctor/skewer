require 'singleton'

class SkewerConfig
  attr_accessor :aws_service
  
  include Singleton

  def self.set(attribute, value)
    self.instance_variable_set "@#{attribute}", value
  end

  def self.get(attribute)
     self.instance_variable_get "@" + attribute
   end
end

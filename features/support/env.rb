require 'aruba/cucumber'

Before do
  @dirs = [Dir.pwd]
  @aruba_timeout_seconds = 120
end

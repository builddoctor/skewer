require 'aruba/cucumber'

Before do
  @dirs = [Dir.pwd]
  @aruba_timeout_seconds = 600
end

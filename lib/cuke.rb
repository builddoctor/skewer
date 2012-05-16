module Skewer
  # Runs the Cucumber features for a given directory.
  #
  # Specifically, the tests related to infrastructure that skewer
  # will map against to check if the node has been successfully
  # built.
  class Cuke
    "responsible for calling cucumber post-run"
    include Skewer

    def initialize(dir = nil, host = nil)
      raise "you must provide a valid directory for features to be executed within" unless File.directory?(dir)
      @dir = dir
      @host = host
    end

    def run
      Skewer.logger.debug("Running cucumber hook")
      `cd #{@dir}/.. && bundle install` if File.join(@dir, '..', 'Gemfile')
      result = `cucumber #{@dir} SKEWER_HOST=#{@host}`
      parsed = result.match(/failed/)[0] rescue false
      raise  "One of the Cucumber features failed!\n\n#{result}" if parsed
      result
    end
  end
end

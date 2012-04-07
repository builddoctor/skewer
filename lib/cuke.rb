module Skewer
  # Runs the Cucumber features for a given directory.
  #
  # Specifically, the tests related to infrastructure that skewer
  # will map against to check if the node has been successfully
  # built.
  class Cuke
    class CukeError < RuntimeError; end
    include Skewer

    def initialize(dir = nil)
      raise "you must provide a valid directory for features to be executed within" if dir.nil? or dir.class != String or  !directory_exists?(dir)
      @dir = dir
    end

    def directory_exists?(dir)
      File.directory?(dir)
    end

    def run
      Skewer.logger.debug("Running cucumber hook")
      `cd #{@dir}/.. && bundle install` if File.join(@dir, '..', 'Gemfile')
      result = `cucumber #{@dir}`
      parsed = result.match(/failed/)[0] rescue false
      raise CukeError, "One of the cuke features failed!\n\n#{result}" if parsed
      result
    end
  end
end

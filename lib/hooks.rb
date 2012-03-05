
module Skewer
  class Hooks

    def initialize(command, host_name, kernel = Kernel)
      @command = command
      @kernel = kernel
      @host_name = host_name
    end

    def run
      @kernel.exec([@command, @host_name])
    end
  end
end
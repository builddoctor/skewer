# This file currently exists for one reason only: to get rcov working.
#
# The require used below makes sure that when rcov invokves the spec/
# folder with lib/ as the files under test, that RSpec runs the tests.
#
# Without doing so, rcov will attempt to look at coverage at a high-level,
# only mapping the use of class names and class methods. Whereas, after
# running the tests rcov has a better understanding of what code has been
# exercised during use. Providing accurate coverage metrics.
require 'rspec/autorun'

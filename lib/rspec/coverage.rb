require "rspec/coverage/version"

require "rspec/coverage/class_map"
require "rspec/coverage/class_map_builder"
require "rspec/coverage/configuration"
require "rspec/coverage/excludes"
require "rspec/coverage/result"
require "rspec/coverage/runner"

require "simplecov"
require "pry"

module RSpec
  module Coverage
    INACTIVE = 0
    ACTIVE   = 1

    def self.root
      Dir.pwd
    end

    def self.config
      @config ||= Configuration.new root
    end

    def self.start *args
      config.start(*args)
    end
  end
end

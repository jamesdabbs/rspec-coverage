module RSpec
  module Coverage
    class Configuration
      attr_reader :root, :builder, :runner

      def initialize root
        @root    = root
        map      = ClassMap.new root
        @builder = ClassMapBuilder.new map
        @runner  = Runner.new map
      end

      def start *args
        @builder.enable

        SimpleCov.start(*args)
        SimpleCov.at_exit do
          SimpleCov.formatter.new.format SimpleCov::Result.new runner.result
        end

        _self = self
        RSpec.configure do |c|
          c.around :each do |example|
            _self.runner.call example
          end
        end
      end
    end
  end
end

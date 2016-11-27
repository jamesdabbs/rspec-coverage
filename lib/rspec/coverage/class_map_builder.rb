module RSpec::Coverage
  class ClassMapBuilder
    def initialize map=nil
      @map   = map
      @trace = TracePoint.new(:class) { |t| handle t }
    end

    def handle trace
      @map.start_class name: trace.self.name, path: trace.path, line: trace.lineno
    end

    def enable
      @trace.enable
    end
  end
end

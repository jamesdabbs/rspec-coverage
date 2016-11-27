module RSpec::Coverage
  class Runner
    def initialize map, coverage: ::Coverage.method(:peek_result)
      @map, @coverage = map, coverage
      @exclusions = Excludes.new map.root
    end

    def call ex
      if klasses = ex.metadata[:covers]
        run_filtered klasses, ex
      elsif klass = ex.metadata[:described_class]
        run_filtered [klass], ex
      else
        ex.call
      end
    end

    def result
      @exclusions.deduct(@coverage.call).to_h
    end

    private

    def run_filtered klasses, example
      before = @coverage.call
      example.call
      @exclusions.record \
        before: before,
        after:  @coverage.call,
        mask:   @map.mask(*klasses)
    end
  end
end

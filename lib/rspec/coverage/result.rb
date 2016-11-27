module RSpec::Coverage
  class Result
    attr_reader :root

    extend Forwardable
    def_delegators :@coverage, :[], :keys

    def self.traverse *results, &block
      new("", results.shift).traverse(*results, &block).to_h
    end

    def traverse *results, &block
      RSpec::Coverage::Result.new(root, @coverage.dup).traverse!(*results, &block)
    end

    def traverse! *results
      results.unshift self
      files = results.map(&:keys).flatten.uniq
      files.each do |file|
        next unless file.start_with? root

        lines = results.map{ |r| r[file] || [] }
        len   = lines.map(&:length).max

        @coverage[file] = len.times.map do |i|
          yield file, *lines.map { |ls| ls[i] }
        end
      end
      self
    end

    def initialize root, coverage={}
      @root, @coverage = root, coverage
    end

    def to_h
      @coverage.dup
    end
  end
end

module RSpec::Coverage
  class Excludes
    attr_reader :root

    def initialize root
      @root, @overs = root, RSpec::Coverage::Result.new(root)
    end

    def record before:, after:, mask:
      @overs.traverse! before, after, mask do |file,o,b,a,m|
        o ||= 0
        b ||= 0
        a ||= 0
        m ||= mask[file] ? mask[file].last : INACTIVE

        if m == INACTIVE
          o + a - b
        else
          o
        end
      end
    end

    def deduct coverage
      @overs.traverse coverage do |file, over, cover|
        next unless cover
        cover - (over || 0)
      end
    end
  end
end

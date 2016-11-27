require "set"

module RSpec::Coverage
  class ClassMap
    attr_reader :root

    def initialize root=""
      @root = root
      @files, @masks, @klasses = {}, {}, {}
    end

    def mask *klasses
      return @masks[klasses] if @masks[klasses]

      masks = klasses.map { |klass| class_mask klass }
      @masks[klasses] = Result.traverse(*masks) do |_file, *entries|
        entries.include?(ACTIVE) ? ACTIVE : INACTIVE
      end
    end

    def start_class name:, path:, line:
      return unless path.start_with? @root

      @files[path] ||= {}
      @files[path][line] = name

      @klasses[name] ||= {}
      @klasses[name][path] = true
    end

    private

    def class_mask klass_or_name
      klass = klass_or_name.respond_to?(:name) ? klass_or_name.name : klass_or_name
      return @masks[klass] if @masks.include?(klass)

      active_files  = (@klasses[klass] || {}).keys
      @masks[klass] = active_files.each_with_object({}) do |file, h|
        h[file] = file_mask file, klass
      end
    end

    def file_mask file, klass
      @files[file].freeze # can't add class defs to a file after computing the map

      fm = @files[file]

      active = INACTIVE
      1.upto(fm.keys.last).map do |i|
        if current = fm[i]
          active = (current == klass) ? ACTIVE : INACTIVE
        end
        active
      end
    end
  end
end

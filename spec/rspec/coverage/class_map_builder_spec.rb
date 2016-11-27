require "spec_helper"

RSpec.describe RSpec::Coverage::ClassMapBuilder do
  A = RSpec::Coverage::ACTIVE
  I = RSpec::Coverage::INACTIVE

  def path p
    File.expand_path "../../lib/#{p}", __FILE__
  end

  it 'can build while loading files' do
    map     = RSpec::Coverage::ClassMap.new path("")
    builder = RSpec::Coverage::ClassMapBuilder.new map
    builder.enable

    load path "base.rb"
    load path "patch.rb"

    expect(map.mask "Base").to eq \
      path("base.rb") => [A],
      path("patch.rb")  => [I,I,I,I,I,I,A]
  end
end

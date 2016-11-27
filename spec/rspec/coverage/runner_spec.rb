require 'spec_helper'

class Example
  def initialize data={}, &block
    @data, @block = data, block
  end

  def metadata; @data; end
  def call; @block.call; end
end

class Coverer
  def initialize sequence
    @sequence = sequence + [sequence.last]
  end

  def call
    @sequence.shift || raise("Coverer exhausted")
  end
end

RSpec.describe RSpec::Coverage::Runner do
  let(:map) {
    RSpec::Coverage::ClassMap.new.tap do |m|
      m.start_class name: "User", path: "user.rb", line: 1
      m.start_class name: "Post", path: "post.rb", line: 1
    end
  }
  let(:coverage) {
    Coverer.new [
      { "user.rb" => [1], "post.rb" => [1] },
      { "user.rb" => [2], "post.rb" => [3] },
    ]
  }

  subject { described_class.new map, coverage: coverage }

  it 'can filter the described class' do
    ex = Example.new(described_class: "User") { 2 + 2 }

    subject.call ex

    expect(subject.result).to eq \
      "user.rb" => [2],
      "post.rb" => [1]
  end

  it 'can filter manually specified classes' do
    ex = Example.new(covers: %w(User Post)) { 2 + 2 }

    subject.call ex

    expect(subject.result).to eq \
      "user.rb" => [2],
      "post.rb" => [3]
  end

  it 'can run without filtering' do
    ex = Example.new { 2 + 2 }

    coverage.call # pop before coverage
    subject.call ex

    expect(subject.result).to eq \
      "user.rb" => [2],
      "post.rb" => [3]
  end
end

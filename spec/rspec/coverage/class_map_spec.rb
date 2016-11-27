require 'spec_helper'

RSpec.describe RSpec::Coverage::ClassMap do
  A = RSpec::Coverage::ACTIVE
  I = RSpec::Coverage::INACTIVE

  subject { described_class.new 'lib' }

  it 'can mask one class per file' do
    subject.start_class name: 'User', path: 'lib/user.rb', line: 1
    subject.start_class name: 'Post', path: 'lib/post.rb', line: 1

    mask = subject.mask "User"

    expect(mask).to eq \
      "lib/user.rb" => [A]
  end

  it 'handles multiple classes in one file' do
    subject.start_class name: 'User',  path: 'lib/user.rb', line: 1
    subject.start_class name: 'Post',  path: 'lib/user.rb', line: 3
    subject.start_class name: 'Other', path: 'lib/user.rb', line: 5
    subject.start_class name: 'User',  path: 'lib/user.rb', line: 7

    mask = subject.mask "User"

    expect(mask).to eq \
      "lib/user.rb" => [A,A,I,I,I,I,A]
  end

  it 'handles one class across multiple files' do
    subject.start_class name: 'User', path: 'lib/user.rb', line: 1
    subject.start_class name: 'Post', path: 'lib/post.rb', line: 1
    subject.start_class name: 'User', path: 'lib/post.rb', line: 4

    mask = subject.mask "User"

    expect(mask).to eq \
      "lib/user.rb" => [A],
      "lib/post.rb" => [I,I,I,A]
  end

  it 'freezes files when mapped' do
    subject.start_class name: 'User', path: 'lib/user.rb', line: 1

    subject.mask "User"

    expect do
      subject.start_class name: 'Post', path: 'lib/user.rb', line: 3
    end.to raise_error(/frozen/)
  end

  it 'filters non-root files' do
    subject.start_class name: 'Gem', path: 'gems/gem.rb', line: 1

    expect(subject.mask "Gem").to eq({})
  end
end

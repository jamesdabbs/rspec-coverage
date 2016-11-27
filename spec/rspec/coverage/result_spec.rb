require 'spec_helper'

RSpec.describe RSpec::Coverage::Result do
  let(:before) { described_class.new "", \
    "user.rb" => [1,1,1],
    "post.rb" => [0,0,0]
  }
  let(:after) { described_class.new "", \
    "user.rb" => [1,2,3],
    "post.rb" => [3,3,3],
    "new.rb"  => [5,5]
  }
  let(:mask) { {
    "user.rb" => [1,0,1],
    "post.rb" => [0,1]
  } }

  it 'can traverse results' do
    result = after.traverse(before, mask) do |_file,a,b,m|
      a ||= 0
      b ||= 0
      m ||= 0
      (a - b) * m
    end

    expect(result.to_h).to eq \
      "user.rb" => [0,0,2],
      "post.rb" => [0,3,0],
      "new.rb"  => [0,0]
  end
end

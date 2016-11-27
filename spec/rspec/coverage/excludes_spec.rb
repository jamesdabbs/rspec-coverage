require "spec_helper"

RSpec.describe RSpec::Coverage::Excludes do
  let(:root) { "" }

  subject { described_class.new root }

  let(:before) { RSpec::Coverage::Result.new root, \
    "user.rb" => [1,1,1],
    "post.rb" => [0,0,0]
  }
  let(:after) { RSpec::Coverage::Result.new root, \
    "user.rb" => [1,2,3],
    "post.rb" => [3,3,3],
    "new.rb"  => [5,5]
  }
  let(:mask) { {
    "user.rb" => [1,0,1],
    "post.rb" => [0,1]
  } }

  it 'can record an exclusion' do
    subject.record before: before, after: after, mask: mask

    result = subject.deduct after

    expect(result["user.rb"]).to eq [1,1,3]
    expect(result["post.rb"]).to eq [0,3,3]
    expect(result["new.rb" ]).to eq [0,0]
  end
end

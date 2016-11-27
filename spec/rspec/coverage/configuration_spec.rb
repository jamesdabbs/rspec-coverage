require 'spec_helper'

RSpec.describe RSpec::Coverage::Configuration do
  it 'can be started' do
    expect(RSpec::Coverage.config.builder).to receive(:enable)
    expect(SimpleCov).to receive(:start)
    expect(SimpleCov).to receive(:at_exit)
    expect(RSpec.configuration).to receive(:around).with(:each)

    RSpec::Coverage.start
  end
end

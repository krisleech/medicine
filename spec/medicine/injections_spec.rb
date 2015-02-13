RSpec.describe Medicine::Injections do
  subject { described_class.new({}) }

  it 'is frozen' do
    expect(subject).to be_frozen
  end
end

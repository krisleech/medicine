RSpec.describe Medicine::DI do
  it 'can be included' do
    klass = Class.new { include Medicine::DI }
    expect(klass).to respond_to(:dependencies)
  end

  it 'can be prepended' do
    klass = Class.new { prepend Medicine::DI }
    expect(klass).to respond_to(:dependencies)
  end
end

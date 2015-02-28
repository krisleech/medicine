RSpec.describe Medicine::Dependency do
  subject { described_class }

  TOKEN = Class.new

  describe '#initialize' do
    it 'sets name' do
      expect(subject.new(TOKEN, {}).name).to eq TOKEN
    end

    context 'given default option' do
      let(:dependency) { subject.new('foo', default: TOKEN) }

      it 'sets default to given value' do
        expect(dependency.default).to eq TOKEN
      end
    end

    context 'without default option' do
      let(:dependency) { subject.new('foo') }

      it 'raises an error' do
        expect { dependency.default }.to raise_error(Medicine::NoDefaultError)
      end
    end
  end

  describe '#required?' do
    context 'when has default' do
      let(:dependency) { subject.new('foo', default: TOKEN) }

      it 'returns false' do
        expect(dependency.required?).to be_falsey
      end
    end

    context 'when has no default' do
      let(:dependency) { subject.new('foo') }

      it 'returns true' do
        expect(dependency.required?).to be_truthy
      end
    end
  end

  describe '#default' do
    Foo  = Class.new
    Foos = Class.new

    let(:dependency) { subject.new('foo', default: default) }

    describe 'when initalized with a class' do
      let(:default) { Foo }

      it 'returns a class' do
        expect(dependency.default).to eq Foo
      end
    end

    describe 'when initialized with a lambda' do
      let(:default) { -> { Foo } }

      it 'returns a class' do
        expect(dependency.default).to eq Foo
      end
    end

    describe 'when initialized with a Proc' do
      let(:default) { Proc.new { Foo } }

      it 'returns a class' do
        expect(dependency.default).to eq Foo
      end
    end

    describe 'when initialized with a CamelCase String' do
      let(:default) { 'Foo' }

      it 'returns a class' do
        expect(dependency.default).to eq Foo
      end
    end

    describe 'when initialized with a plural CamelCase String' do
      let(:default) { 'Foos' }

      it 'returns a class' do
        expect(dependency.default).to eq Foos
      end
    end

    describe 'when initialized with a CamelCase Symbol' do
      let(:default) { :Foo }

      it 'returns a class' do
        expect(dependency.default).to eq Foo
      end
    end

    describe 'when initialized with a lowercase Symbol' do
      let(:default) { :foo }

      it 'returns a class' do
        expect(dependency.default).to eq Foo
      end
    end
  end
end


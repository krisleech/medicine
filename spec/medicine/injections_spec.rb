RSpec.describe Medicine::Injections do
  subject { described_class.new }

  let(:dependency) { double }
  let(:name)       { :name }

  describe '#set' do
    it 'sets a dependency for name' do
      subject.set(name, dependency)
      expect(subject.get(name)).to eq dependency
    end

    context 'when dependency has already been set' do
      pending 'it issues a warning'
    end
  end

  describe '#get' do
    context 'given a known name' do
      it 'gets a dependency by name' do
        subject.set(name, dependency)
        expect(subject.get(name)).to eq dependency
      end
    end

    context 'given an unknown name' do
      context 'and no block given' do
        it 'raise an error' do
          expect { subject.get(:made_up_name) }.to raise_error(ArgumentError)
        end
      end

      context 'and block given' do
        # FIXME: assert block is called
        it 'does not raise an error' do
          expect { subject.get(:made_up_name) {  } }.not_to raise_error
        end
      end
    end
  end

  describe '#[]' do
    it 'is aliased to #get' do
      expect(subject).to receive(:get).with(:foo)
      subject[:foo]
    end
  end

  describe '#empty?' do
    context 'when no dependencies' do
      it 'returns true' do
        expect(subject.empty?).to be_truthy
      end
    end
  end

  describe '#include?' do
    context 'given known name' do
      it 'returns true' do
        subject.set(name, dependency)
        expect(subject.include?(name)).to be_truthy
      end
    end

    context 'given an unknown name' do
      it 'returns false' do
        expect(subject.include?(:made_up_name)).to be_falsey
      end
    end
  end
end

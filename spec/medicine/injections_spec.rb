RSpec.describe Medicine::Injections do
  subject { described_class.new }

  let(:dependency) { double }
  let(:name)       { :name }

  describe '#set' do
    it 'sets a dependency for name' do
      subject.set(name, dependency)
      expect(subject.fetch(name)).to eq dependency
    end

    context 'when dependency has already been set' do
      it 'issues a warning' do
        expect(subject).to receive(:warn)
        subject.set(name, dependency)
        subject.set(name, dependency)
      end
    end
  end

  describe '#fetch' do
    context 'given a known name' do
      it 'gets a dependency by name' do
        subject.set(name, dependency)
        expect(subject.fetch(name)).to eq dependency
      end
    end

    context 'given an unknown name' do
      context 'and no block given' do
        it 'raise an error' do
          expect { subject.fetch(:made_up_name) }.to raise_error(ArgumentError)
        end
      end

      context 'and block given' do
        # FIXME: assert block is called
        it 'does not raise an error' do
          expect { subject.fetch(:made_up_name) {  } }.not_to raise_error
        end
      end
    end
  end

  describe '#[]' do
    context 'given a known name' do
      it 'returns dependency' do
        subject.set(name, dependency)
        expect(subject[name]).to eq dependency
      end
    end

    context 'given an unknown name' do
      it 'returns nil' do
        expect(subject[name]).to eq nil
      end
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

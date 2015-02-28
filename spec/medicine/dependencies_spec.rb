RSpec.describe Medicine::Dependencies do
  it 'is a collection' do
    expect(subject).to be_a(Enumerable)
    expect(subject).to respond_to(:each)
  end

  describe '#[]' do
    context 'when dependency is known' do
      before { subject.add(:foo) }

      it 'returns a dependency' do
        expect(subject[:foo]).to an_instance_of(Medicine::Dependency)
      end
    end

    context 'when dependency is unknown' do
      it 'returns nil' do
        expect(subject[:foo]).to be_nil
      end
    end
  end

  describe '#fetch' do
    context 'when dependency is known' do
      before { subject.add(:foo) }

      it 'returns a dependency' do
        expect(subject.fetch(:foo)).to an_instance_of(Medicine::Dependency)
      end
    end

    context 'when when dependency is unknown' do
      it 'raise an error' do
        expect { subject.fetch(:foo) }.to raise_error(Medicine::UnknownDependency, "Dependency foo is unknown")
      end
    end
  end

  describe '#include?' do
    context 'when dependency is known' do
      before { subject.add(:foo) }

      it 'returns true' do
        expect(subject.include?(:foo)).to be_truthy
      end
    end

    context 'when when dependency is unknown' do
      it 'returns false' do
        expect(subject.include?(:foo)).to be_falsey
      end
    end
  end

  describe '#<<' do
    it 'appends given dependency' do
      expect { subject << double }.to change { subject.size }.by(1)
    end
  end

  describe '#add' do
    it 'appends dependency' do
      expect { subject.add('foo') }.to change { subject.size }.by(1)
    end

    context 'options' do
      let(:added_dependency) { subject.first }

      context 'default given' do
        let(:default) { double }
        let(:options) { { default: default } }

        before { subject.add('foo', options) }

        it 'sets default' do
          expect(added_dependency).to be_default
        end
      end

      context 'default not given' do
        let(:options) { {} }

        before { subject.add('foo', options) }

        it 'appends dependency without default' do
          expect(added_dependency).not_to be_default
        end
      end
    end
  end

  describe '#without_defaults' do
    let(:dependency_with_default)    { double('Dependency', default?: true) }
    let(:dependency_without_default) { double('Dependency', default?: false) }

    it 'returns dependencies without a default' do
      subject << dependency_without_default
      subject << dependency_with_default

      expect(subject.without_default).to eq [dependency_without_default]
    end
  end

  context 'initialize' do
    it 'is empty' do
      expect(subject).to be_empty
    end
  end
end

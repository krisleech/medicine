RSpec.describe Medicine::Dependencies do
  it 'is a collection' do
    expect(subject).to be_a(Enumerable)
    expect(subject).to respond_to(:each)
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

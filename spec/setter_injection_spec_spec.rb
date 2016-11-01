RSpec.describe 'Medicine' do
    let(:medicated_class) { new_medicated_class }

    def new_medicated_class
      Class.new do
        include Medicine.di

        # access to otherwise private method
        def _vote_repo
          vote_repo
        end
      end
    end

    subject { medicated_class.new }

  describe '#injections' do
    it 'starts empty' do
      expect(subject.injections).to be_empty
    end

    it 'returns Injections object' do
      expect(subject.injections).to be_an_instance_of(Medicine::Injections)
    end

    it 'is frozen' do
      expect(subject.injections).to be_frozen
    end
  end

  describe '#inject_dependency' do
    it 'is a public method' do
      expect(subject).to respond_to :inject_dependency
    end

    it 'injects a dependency' do
      medicated_class.class_eval { dependency :name }
      subject.inject_dependency(:name, double)
      expect(subject.injections).not_to be_empty
    end

    describe 'when dependency has not been declared' do
      it 'raises an error' do
        expect { subject.inject_dependency(:name, double) }.to raise_error(Medicine::DependencyUnknownError)
      end
    end
  end

  describe '#injects' do
    it 'is a public method' do
      expect(subject).to respond_to :injects
    end

    it 'invokes inject for each dependency' do
      medicated_class.class_eval { dependency :name }
      expect(subject).to receive(:inject_dependency).twice
      subject.injects(name: double, other: double)
    end
  end
end

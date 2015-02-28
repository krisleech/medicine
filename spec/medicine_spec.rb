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

  describe 'when dependency declared' do
    it 'survives inheritence' do
      medicated_class.class_eval { dependency :vote_repo }

      super_medicated_class = Class.new(medicated_class)
      expect(super_medicated_class.dependencies).not_to be_empty
    end

    it 'does not leak between unrelated classes' do
      medicated_class.class_eval { dependency :vote_repo }

      expect(medicated_class.dependencies).not_to be_empty
      expect(new_medicated_class.dependencies).to be_empty
    end
  end

  describe 'when dependency declared with no default' do
    before { medicated_class.class_eval { dependency :vote_repo } }

    context 'and dependency not injected' do
      subject { medicated_class.new }

      it 'raises an error' do
        expect { subject._vote_repo }.to raise_error(Medicine::NoInjectionError, /Dependency not injected and default not declared/)
      end
    end
  end

  describe 'dependency declared with default' do

    subject { medicated_class.new }

    before do
      Foo  = Class.new unless defined?(Foo)
      Foos = Class.new unless defined?(Foos)
    end

    describe 'as a class' do
      before { medicated_class.class_eval { dependency :vote_repo, default: Foo } }

      it 'returns a class' do
        expect(subject._vote_repo).to eq Foo
      end
    end

    describe 'as a lambda' do
      before { medicated_class.class_eval { dependency :vote_repo, default: -> { Foo } } }

      it 'returns a class' do
        expect(subject._vote_repo).to eq Foo
      end
    end

    describe 'as a Proc' do
      before { medicated_class.class_eval { dependency :vote_repo, default: Proc.new { Foo } } }

      it 'returns a class' do
        expect(subject._vote_repo).to eq Foo
      end
    end

    describe 'as a CamelCase String' do
      before { medicated_class.class_eval { dependency :vote_repo, default: 'Foo' } }

      it 'returns a class' do
        expect(subject._vote_repo).to eq Foo
      end
    end

    describe 'as a plural CamelCase String' do
      before { medicated_class.class_eval { dependency :vote_repo, default: 'Foos' } }

      it 'returns a class' do
        expect(subject._vote_repo).to eq Foos
      end
    end

    describe 'as a CamelCase Symbol' do
      before { medicated_class.class_eval { dependency :vote_repo, default: :Foo} }

      it 'returns a class' do
        expect(subject._vote_repo).to eq Foo
      end
    end

    describe 'as a lowercase Symbol' do
      before { medicated_class.class_eval { dependency :vote_repo, default: :foo} }

      it 'returns a class' do
        expect(subject._vote_repo).to eq Foo
      end
    end
  end # with default option

  describe 'object initialization' do
    it 'zsuper is called' do
      klass = Class.new do
        prepend Medicine.di

        attr_reader :initalize_reached

        def initialize(*args)
          @initalize_reached = true
        end
      end

      expect(klass.new.initalize_reached).to be_truthy
    end
  end
end

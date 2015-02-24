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

  describe 'dependency declarations' do
    it 'survive inheritence' do
      medicated_class.class_eval { dependency :foobar }

      super_medicated_class = Class.new(medicated_class)
      expect(super_medicated_class.dependencies).not_to be_empty
    end

    it 'do not leak between unrelated classes' do
      medicated_class.class_eval { dependency :foobar }

      expect(medicated_class.dependencies).not_to be_empty
      expect(new_medicated_class.dependencies).to be_empty
    end
  end

  describe 'dependency declared without any options' do
    before { medicated_class.class_eval { dependency :vote_repo } }

    context 'and subject initalized with hash' do
      subject { medicated_class.new(vote_repo: :foo) }

      context 'and hash has key for dependency' do
        it 'provides a private method' do
          expect(subject.respond_to?(:vote_repo, true)).to be_truthy
        end

        it 'does not provide a public method' do
          expect(subject).not_to respond_to(:vote_repo)
        end

        it 'provides method which returns injected value' do
          expect(subject._vote_repo).to eq :foo
        end
      end
    end
  end

  context 'and subject initialized with no arguments' do

    subject { medicated_class.new }

    before do
      Foo  = Class.new unless defined?(Foo)
      Foos = Class.new unless defined?(Foos)
    end

    describe 'and dependency declared with default option' do

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
  end # initialized with no arguments

  describe 'inclusion of module' do
    it 'can be included' do
      klass = Class.new { include Medicine.di }
      expect(klass).to respond_to(:dependencies)
    end

    it 'can be prepended' do
      klass = Class.new { prepend Medicine.di }
      expect(klass).to respond_to(:dependencies)
    end
  end

  it 'does not resolve default when injected' do
    medicated_class.class_eval do
      dependency :foo, default: -> { DoesNotExist }
    end

    object = medicated_class.new(foo: 'bar')
    expect { object.send(:foo) }.not_to raise_error
  end

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
end # rspec

RSpec.describe 'Medicine' do
  let(:klass) do
    Class.new do
      include Medicine.di

      # access to otherwise private method
      def _vote_repo
        vote_repo
      end
    end
  end

  describe 'dependency declrations' do
    it 'survive inheritence' do
      klass.class_eval { dependency :foobar }

      super_klass = Class.new(klass)
      expect(super_klass.dependencies).not_to be_empty
    end
  end

  describe 'dependency declared without any options' do
    before { klass.class_eval { dependency :vote_repo } }

    context 'and subject initialized with no arguments' do
      subject { klass.new }

      it 'raises exception' do
        expect { subject }.to raise_error(Medicine::RequiredDependencyError)
      end
    end

    context 'and subject initalized with hash' do
      subject { klass.new(vote_repo: :foo) }

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

      context 'and hash has no key for dependency' do
        subject { klass.new({}) }

        it 'raises exception' do
          expect { subject }.to raise_error(Medicine::RequiredDependencyError)
        end
      end
    end
  end

  context 'and subject initialized with no arguments' do

    subject { klass.new }

    before do
      Foo  = Class.new unless defined?(Foo)
      Foos = Class.new unless defined?(Foos)
    end

    describe 'and dependency declared with default option' do

      describe 'as a class' do
        before { klass.class_eval { dependency :vote_repo, default: Foo } }

        it 'returns a class' do
          expect(subject._vote_repo).to eq Foo
        end
      end

      describe 'as a lambda' do
        before { klass.class_eval { dependency :vote_repo, default: -> { Foo } } }

        it 'returns a class' do
          expect(subject._vote_repo).to eq Foo
        end
      end

      describe 'as a Proc' do
        before { klass.class_eval { dependency :vote_repo, default: Proc.new { Foo } } }

        it 'returns a class' do
          expect(subject._vote_repo).to eq Foo
        end
      end

      describe 'as a CamelCase String' do
        before { klass.class_eval { dependency :vote_repo, default: 'Foo' } }

        it 'returns a class' do
          expect(subject._vote_repo).to eq Foo
        end
      end

      describe 'as a plural CamelCase String' do
        before { klass.class_eval { dependency :vote_repo, default: 'Foos' } }

        it 'returns a class' do
          expect(subject._vote_repo).to eq Foos
        end
      end

      describe 'as a CamelCase Symbol' do
        before { klass.class_eval { dependency :vote_repo, default: :Foo} }

        it 'returns a class' do
          expect(subject._vote_repo).to eq Foo
        end
      end

      describe 'as a lowercase Symbol' do
        before { klass.class_eval { dependency :vote_repo, default: :foo} }

        it 'returns a class' do
          expect(subject._vote_repo).to eq Foo
        end
      end
    end # with default option
  end # initialized with no arguments
end # rspec

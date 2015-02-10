RSpec.describe 'Medicine' do
  let(:klass) do
    Class.new do
      include Medicine.di
    end
  end

  describe '.dependency' do

    describe 'without any options' do
      before { klass.class_eval { dependency :vote_repo } }

      context 'initialized with no arguments' do
        subject { klass.new }

        it 'initialization raises error' do
          expect { subject }.to raise_error(Medicine::DI::ArgumentError)
        end
      end

      context 'when initalized with hash' do
        subject { klass.new(vote_repo: :foo) }

        context 'and hash has key for dependency' do
          it 'responds to dependency name' do # TODO: method should be private
            expect(subject).to respond_to(:vote_repo)
          end

          it 'provides method which returns injected value' do
            expect(subject.vote_repo).to eq :foo
          end
        end

        context 'hash has no key for dependency' do
          subject { klass.new({}) }

          it 'raises error' do
            expect { subject }.to raise_error(Medicine::DI::ArgumentError)
          end
        end
      end

      context 'initalized with arguments and hash' do
        before do
          klass.class_eval do
            def initialize(arg1, arg2, deps)
              super
            end
          end
        end

        context 'and hash has key for dependency' do
          subject { klass.new(double, double, vote_repo: :foo) }

          skip 'provides method for dependency' do
            expect(subject).to respond_to(:vote_repo)
          end
        end

        context 'hash has no key for dependency' do
          subject { klass.new(double, double, {}) }

          skip 'raises error' do
            expect { subject }.to raise_error(Medicine::DI::ArgumentError)
          end
        end
      end
    end

    context 'initialized with no arguments' do

      subject { klass.new }

      before do
        Foo  = Class.new unless defined?(Foo)
        Foos = Class.new unless defined?(Foos)
      end

      describe 'dependency declared with default option' do

        describe 'as a class' do
          before { klass.class_eval { dependency :vote_repo, default: Foo } }

          it 'returns declared default class' do
            expect(subject.vote_repo).to eq Foo
          end
        end

        describe 'as a CamelCase String' do
          before { klass.class_eval { dependency :vote_repo, default: 'Foo' } }

          it 'returns declared default typecast to a class' do
            expect(subject.vote_repo).to eq Foo
          end
        end

        describe 'as a plural CamelCase String' do
          before { klass.class_eval { dependency :vote_repo, default: 'Foos' } }

          it 'returns declared default typecast to a class' do
            expect(subject.vote_repo).to eq Foos
          end
        end

        describe 'as a CamelCase Symbol' do
          before { klass.class_eval { dependency :vote_repo, default: :Foo} }

          it 'returns declared default typecast to a class' do
            expect(subject.vote_repo).to eq Foo
          end
        end

        describe 'as a lowercase Symbol' do
          before { klass.class_eval { dependency :vote_repo, default: :foo} }

          it 'returns declared default typecast to a class' do
            expect(subject.vote_repo).to eq Foo
          end
        end
      end # with default option
    end # initialized with no arguments

  end # .dependency
end # rspec

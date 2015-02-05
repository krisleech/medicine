RSpec.describe 'Isopod' do
  let(:klass) do
    Class.new do
      include Isopod.di
    end
  end

  describe '.dependency' do

    describe 'without any options' do
      before { klass.class_eval { dependency :vote_repo } }

      context 'initialized with no arguments' do
        subject { klass.new }

        it 'initialization raises error' do
          expect { subject }.to raise_error(Isopod::DI::ArgumentError)
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
            expect { subject }.to raise_error(Isopod::DI::ArgumentError)
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
            expect { subject }.to raise_error(Isopod::DI::ArgumentError)
          end
        end
      end
    end

    describe 'with default option' do
      describe 'of type String' do
        before { klass.class_eval { dependency :vote_repo, default: 'Object' } }

        context 'and initializer given no arguments' do

          subject { klass.new }

          it 'responds to dependency name' do
            expect(subject).to respond_to(:vote_repo)
          end

          it 'returns given default typecast to a class' do
            expect(subject.vote_repo).to be_an_instance_of(Object)
          end
        end
      end
    end # with default option

  end # .dependency
end # rspec

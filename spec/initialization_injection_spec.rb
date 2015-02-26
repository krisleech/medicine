RSpec.describe 'injection via initializer' do
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

  before { medicated_class.class_eval { dependency :vote_repo } }

  context 'when subject is initalized with a hash' do
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

      it 'does not resolve default' do
        medicated_class.class_eval do
          dependency :vote_repo, default: -> { DoesNotExist }
        end

        object = medicated_class.new(vote_repo: 'bar')
        expect { object._vote_repo.not_to raise_error }
      end
    end
  end
end

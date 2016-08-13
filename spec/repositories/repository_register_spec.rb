RSpec.describe RepositoryRegister do
  let(:mem_repo) { InMemoryRepository.new }
  let(:valid_assign) { RepositoryRegister.register(:new_key, mem_repo) }

  describe '.register' do
    context 'when a valid Repository is passed' do
      it 'accepts it and register with no errors' do
        expect { valid_assign }.to change { RepositoryRegister.repositories.size }.by(1)
      end
    end

    context 'when a invalid Repository is passed' do
      it 'raises an ArgumentError' do
        expect { RepositoryRegister.register(:new_key, Object.new) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.repositories' do
    before { valid_assign }

    it 'returns all available repositories' do
      expect(RepositoryRegister.repositories).not_to be_empty
    end
  end

  describe '.repository_for' do
    before { valid_assign }

    it 'correctly returns the associated repository' do
      expect(RepositoryRegister.repository_for(:new_key)).to eq mem_repo
    end
  end
end

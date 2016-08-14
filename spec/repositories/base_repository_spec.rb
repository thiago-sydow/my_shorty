RSpec.describe RedisRepository do
  let(:base_repo) { BaseRepository.new }

  describe '#create_short_code' do
    it { expect { base_repo.create_short_code(anything, anything) }.to raise_error(NotImplementedError) }
  end

  describe '#find' do
    it { expect { base_repo.find(anything) }.to raise_error(NotImplementedError) }
  end

  describe '#exists?' do
    it { expect { base_repo.exists?(anything) }.to raise_error(NotImplementedError) }
  end

  describe '#update' do
    it { expect { base_repo.update(anything, anything) }.to raise_error(NotImplementedError) }
  end

end

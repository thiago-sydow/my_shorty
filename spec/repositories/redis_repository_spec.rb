RSpec.describe RedisRepository do
  let(:redis_repo) { RedisRepository.new }
  let(:code) { 'my_code' }
  let(:url) { 'http://myurl.com'}
  let(:expected) { { url: url, start_date: Time.now.iso8601, redirect_count: 0, last_seen_date: nil } }

  before { Timecop.freeze(Time.now) }
  after { Timecop.return }

  describe '#create_short_code' do
    it 'creates the attribues for that code' do
      expect(redis_repo.create_short_code(code, url)).to eq expected
    end
  end

  describe '#find' do
    before { redis_repo.create_short_code(code, url) }

    context 'when code does not exists' do
      it 'returns nil' do
        expect(redis_repo.find('another_code')).to be_nil
      end
    end

    context 'when code exists' do
      it 'correctly finds the attributes for that code' do
        expect(redis_repo.find(code)).to eq expected
      end
    end
  end

  describe '#exists?' do
    before { redis_repo.create_short_code(code, url) }

    context 'when code does not exists' do
      it { expect(redis_repo.exists?('another_code')).to be_falsey }
    end

    context 'when code exists' do
      it { expect(redis_repo.exists?(code)).to be_truthy }
    end
  end

  describe '#update' do
    let(:updated) { { url: url, start_date: Time.now.iso8601, redirect_count: 1, last_seen_date: nil } }

    before do
      redis_repo.create_short_code(code, url)
      redis_repo.update(code, updated)
    end

    context 'when code does not exists' do
      it { expect(redis_repo.find(code)).to eq updated }
    end
  end

end

RSpec.describe InMemoryRepository do
  let(:mem_repo) { InMemoryRepository.new }
  let(:code) { 'my_code' }
  let(:url) { 'http://myurl.com'}
  let(:expected) { { url: url, start_date: Time.now, redirect_count: 0, last_seen_date: nil } }

  before { Timecop.freeze(Time.now) }
  after { Timecop.return }

  describe '#create_short_code' do
    it 'creates the attribues for that code' do
      expect(mem_repo.create_short_code(code, url)).to eq expected
    end
  end

  describe '#find' do
    before { mem_repo.create_short_code(code, url) }

    context 'when code does not exists' do
      it 'returns nil' do
        expect(mem_repo.find('another_code')).to be_nil
      end
    end

    context 'when code exists' do
      it 'correctly finds the attributes for that code' do
        expect(mem_repo.find(code)).to eq expected
      end
    end
  end

  describe '#exists?' do
    before { mem_repo.create_short_code(code, url) }

    context 'when code does not exists' do
      it { expect(mem_repo.exists?('another_code')).to be_falsey }
    end

    context 'when code exists' do
      it { expect(mem_repo.exists?(code)).to be_truthy }
    end
  end

  describe '#update' do
    let(:updated) { { url: url, start_date: Time.now, redirect_count: 1, last_seen_date: nil } }

    before do
      mem_repo.create_short_code(code, url)
      mem_repo.update(code, updated)
    end

    context 'when code does not exists' do
      it { expect(mem_repo.find(code)).to eq updated }
    end
  end

end

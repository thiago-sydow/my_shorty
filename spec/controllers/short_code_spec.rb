RSpec.describe MyShorty::ShortCode do

  describe 'GET /' do
    it 'returns ok' do
      get '/'
      expect(last_response).to be_ok
    end
  end

end

RSpec.describe ShortCodeController, type: :request do
  describe 'POST /shorten' do
    context 'with valid parameters' do
      context 'when shortcode param is not present' do
        let(:params) { { url: 'http://myshorty.com' } }

        before { post '/shorten', params }

        it { expect(last_response).to be_created }

        it 'returns a generated shortcode' do
          expect(json_body['shortcode']).not_to be_empty
        end
      end

      context 'when shortcode param is present' do
        let(:params) { { url: 'http://myshorty.com', shortcode: 'preferred_shortcode' } }

        before { post '/shorten', params }

        context 'and this shortcode is available' do
          it { expect(last_response).to be_created }
          it { expect(json_body['shortcode']).to eq params[:shortcode] }
        end

        context 'and this shortcode is not available' do
          it { expect(last_response).to be_created }

          it 'returns a generated shortcode' do
            expect(json_body['shortcode']).not_to be_empty
          end
        end
      end
    end

    context 'when url is not present' do
      before { post '/shorten', {} }

      it { expect(last_response).to be_bad_param }
      it { expect(json_body['description']).to eq 'url is not present' }
    end

    context 'when param shortcode is invalid' do
      before { post '/shorten', { url: 'http://myshorty.com', shortcode: 'invalid-code' } }

      it { expect(last_response).to be_bad_param }
      it { expect(json_body['description']).to eq 'invalid shortcode' }
    end
  end
end

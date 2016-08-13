RSpec.describe ShortCodeController, type: :request do
  describe 'POST /shorten' do
    context 'with valid parameters' do
      context 'when shortcode param is not present' do
        let(:params) { { url: 'http://myshorty.com' } }

        before { post '/shorten', params }

        it { expect(last_response.status).to eq 201 }

        it 'returns a generated shortcode' do
          expect(json_body['shortcode']).not_to be_empty
        end
      end

      context 'when shortcode param is present' do
        let(:params) { { url: 'http://myshorty.com', shortcode: 'preferred_shortcode' } }

        context 'and this shortcode is available' do
          before { post '/shorten', params }

          it { expect(last_response.status).to eq 201 }
          it { expect(json_body['shortcode']).to eq params[:shortcode] }
        end

        context 'and this shortcode is not available' do
          before do
            post '/shorten', params
            post '/shorten', params
          end

          it { expect(last_response.status).to eq 409 }
        end
      end
    end

    context 'when url is not present' do
      before { post '/shorten', {} }

      it { expect(last_response.status).to eq 400 }
      it { expect(json_body['description']).to eq 'url is not present' }
    end

    context 'when param shortcode is invalid' do
      before { post '/shorten', { url: 'http://myshorty.com', shortcode: 'invalid-code' } }

      it { expect(last_response.status).to eq 422 }
      it { expect(json_body['description']).to eq 'Invalid shortcode' }
    end
  end

  context 'GET /:shortcode' do
    let(:params) { { url: 'http://myshorty.com', shortcode: 'my_short_code' } }
    before { post '/shorten', params }

    context 'when :shortcode is in database' do
      before { get "/#{params[:shortcode]}" }

      it { expect(last_response.status).to eq 302 }
      it { expect(last_response.header['Location']).to eq params[:url] }
    end

    context 'when :shortcode is not in database' do
      before { get "/yet_another_code" }

      it { expect(last_response.status).to eq 404 }
    end
  end
end

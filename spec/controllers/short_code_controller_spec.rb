RSpec.describe ShortCodeController, type: :request do
  let(:json_headers) { { 'CONTENT_TYPE' => 'application/json' } }

  describe 'POST /shorten' do
    context 'with valid parameters' do
      context 'when shortcode param is not present' do
        let(:params) { { url: 'http://myshorty.com' } }

        before { post '/shorten', params.to_json, json_headers }

        it { expect(last_response.status).to eq 201 }

        it 'returns a generated shortcode' do
          expect(json_body['shortcode']).not_to be_empty
        end
      end

      context 'when shortcode param is present' do
        let(:params) { { url: 'http://myshorty.com', shortcode: 'preferred_shortcode' } }

        context 'and this shortcode is available' do
          before { post '/shorten', params.to_json, json_headers }

          it { expect(last_response.status).to eq 201 }
          it { expect(json_body['shortcode']).to eq params[:shortcode] }
        end

        context 'and this shortcode is not available' do
          before do
            post '/shorten', params.to_json
            post '/shorten', params.to_json
          end

          it { expect(last_response.status).to eq 409 }
        end
      end
    end

    context 'when url is not present' do
      before { post '/shorten', {}.to_json, json_headers }

      it { expect(last_response.status).to eq 400 }
      it { expect(last_response.body).to eq 'url is not present' }
    end

    context 'when param shortcode is invalid' do
      before { post '/shorten', { url: 'http://myshorty.com', shortcode: 'invalid-code' }.to_json, json_headers }

      it { expect(last_response.status).to eq 422 }
      it { expect(last_response.body).to eq 'Invalid shortcode' }
    end
  end

  context 'GET /:shortcode' do
    let(:params) { { url: 'http://myshorty.com', shortcode: 'my_short_code' } }
    before { post '/shorten', params.to_json, json_headers }

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

  context 'GET /:shortcode/stats' do
    let(:params) { { url: 'http://myshorty.com', shortcode: 'my_short_code' } }

    before { post '/shorten', params.to_json, json_headers }

    context 'when :shortcode is in database' do
      before { get "/#{params[:shortcode]}/stats" }

      it { expect(json_body).not_to be_nil }
    end

    context 'when :shortcode is not in database' do
      before { get "/yet_another_code/stats" }

      it { expect(last_response.status).to eq 404 }
    end
  end
end

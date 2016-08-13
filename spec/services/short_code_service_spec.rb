RSpec.describe ShortCodeService do
  describe '#create_code' do
    context 'when url is nil' do
      let(:service) { ShortCodeService.new(nil, nil) }

      it 'raises a ShortCodeService::UrlNotPresent error' do
        expect { service.create_code }.to raise_error(ShortCodeService::UrlNotPresent)
      end
    end

    context 'when preferred_code is nil' do
      let(:service) { ShortCodeService.new(nil, 'http://url.com') }

      context 'when a new unique code is generated within the MAX_ITERATIONS attempts' do
        it 'returns the new code' do
          expect(service.create_code).not_to be_nil
        end
      end

      context 'when a new unique code cannot be generated within the MAX_ITERATIONS attempts' do
        before { stub_const("ShortCodeService::MAX_ITERATIONS", 0) }

        it 'raises a ShortCodeService::UrlNotPresent error' do
          expect { service.create_code }.to raise_error(ShortCodeService::CouldNotGenerateCode)
        end
      end

    end

    context 'when preferred_code is present' do
      let(:service) { ShortCodeService.new('my_pref_code', 'http://url.com') }

      context 'and the code does not exists yet' do
        it 'generates a new code' do
          expect(service.create_code).to eq 'my_pref_code'
        end
      end

      context 'and the code is already taken' do
        before { service.create_code }

        it 'raises a ShortCodeAlreadyTaken error' do
          expect { service.create_code }.to raise_error(ShortCodeService::ShortCodeAlreadyTaken)
        end
      end
    end
  end
end

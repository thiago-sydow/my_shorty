require 'sinatra/base'

class ShortCodeController < Sinatra::Base
  post '/shorten' do
    service = ShortCodeService.new(params['shortcode'], params['url'])
    generated_code = service.create_code
    [201, { shortcode: generated_code }.to_json]
  end

  get '/:shortcode' do
    service = ShortCodeService.new(params['shortcode'])
    [302, { 'Location' => service.get_redirect_url }, '']
  end

  get '/:shortcode/stats' do
    service = ShortCodeService.new(params['shortcode'])
    [200, service.get_code_stats.to_json]
  end

  configure do
    # Disable unused features to speed up
    disable :method_override
    disable :static

    # Hide exception from users
    set show_exceptions: false
    set :dump_errors, false

    # Set app's root
    set :root, File.dirname(__FILE__)
    enable :logging
  end

  error ShortCodeService::UrlNotPresent do
    [400, { description: 'url is not present' }.to_json]
  end

  error ShortCodeService::InvalidShortCode do
    [422, { description: 'Invalid shortcode' }.to_json]
  end

  error ShortCodeService::ShortCodeAlreadyTaken do
    [409, { description: 'ShortCode already taken' }.to_json]
  end

  error ShortCodeService::ShortCodeNotFound do
    [404, { description: 'ShortCode not found' }.to_json]
  end

end

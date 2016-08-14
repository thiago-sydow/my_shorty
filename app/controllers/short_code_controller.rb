require 'sinatra/base'
require 'json'

class ShortCodeController < Sinatra::Base
  post '/shorten' do
    json_params = JSON.parse(request.body.read)
    service = ShortCodeService.new(json_params['shortcode'], json_params['url'])
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
    [400, 'url is not present']
  end

  error ShortCodeService::InvalidShortCode do
    [422, 'Invalid shortcode']
  end

  error ShortCodeService::ShortCodeAlreadyTaken do
    [409, 'ShortCode already taken']
  end

  error ShortCodeService::ShortCodeNotFound do
    [404, 'ShortCode not found']
  end

end

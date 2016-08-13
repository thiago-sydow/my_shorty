require 'sinatra/base'

class ShortCodeController < Sinatra::Base
  post '/shorten' do
    return [400, { description: 'url is not present' }.to_json] if params['url'].nil?
    return [422, { description: 'Invalid shortcode' }.to_json] unless valid_short_code?

    [201, { shortcode: 'shortcode'.to_s }.to_json]
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

  def valid_short_code?
    shortcode = params['shortcode']
    shortcode.nil? || /^[0-9a-zA-Z_]{4,}$/ =~ shortcode
  end
end

require 'sinatra/base'

class ShortCodeController < Sinatra::Base
  post '/shorten' do
    
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

end

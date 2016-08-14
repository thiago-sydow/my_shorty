ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'byebug'

# Application code
require File.expand_path '../config/environment.rb', __dir__

# Support files
require File.expand_path './support/rspec_mixin.rb', __dir__
require File.expand_path './support/json_helpers.rb', __dir__

RSpec.configure do |config|
  # Disable usage of monkey patch version of describe
  # by preventing global injection of RSpec's DSL
  config.expose_dsl_globally = false
  config.include RSpecMixin, type: :request
  config.include JsonHelpers, type: :request

  config.around(:each) do |example|
    # Redis.new(url: ENV['REDIS_URL']).flushdb
    RepositoryRegister.register(:short_code, InMemoryRepository.new)
    example.run
  end
end

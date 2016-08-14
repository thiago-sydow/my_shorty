source 'https://rubygems.org'

ruby '2.3.1'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'thin'
gem 'redis', '~>3.2'

group :development, :test do
  gem 'byebug'
  gem 'rake'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'timecop'
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: false
end

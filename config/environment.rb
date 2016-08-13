ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require './app/repositories/base_repository'
require './app/repositories/repository_register'
require './app/repositories/in_memory_repository'

configure :development do
  RepositoryRegister.register(:short_code, InMemoryRepository.new)
end

require './app/services/short_code_service'
require './app/controllers/short_code_controller'

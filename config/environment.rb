ENV['RACK_ENV'] ||= 'development'
ENV['REDIS_URL'] ||= 'redis://@localhost:6379/10'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require './app/repositories/base_repository'
require './app/repositories/repository_register'
require './app/repositories/in_memory_repository'
require './app/repositories/redis_repository'

configure :development do
  RepositoryRegister.register(:short_code, RedisRepository.new)
end

configure :production do
  RepositoryRegister.register(:short_code, RedisRepository.new)
end

require './app/services/short_code_service'
require './app/controllers/short_code_controller'

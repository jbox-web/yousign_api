# frozen_string_literal: true

require_relative 'lib/yousign_api/version'

Gem::Specification.new do |s|
  s.name        = 'yousign_api'
  s.version     = YousignApi::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nicoladmin@free.fr']
  s.homepage    = 'https://github.com/jbox-web/yousign-api'
  s.summary     = 'Ruby client for YouSign API'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.5.0'

  s.files = `git ls-files`.split("\n")

  s.add_runtime_dependency 'savon'
  s.add_runtime_dependency 'zeitwerk'

  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
end

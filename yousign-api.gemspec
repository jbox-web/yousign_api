# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'yousign_api/version'

Gem::Specification.new do |s|
  s.name        = 'yousign-api'
  s.version     = YousignApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nicoladmin@free.fr']
  s.homepage    = 'https://github.com/n-rodriguez/yousign-api'
  s.summary     = 'Ruby client for YouSign API'
  s.license     = 'MIT'

  s.add_dependency 'savon'

  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end

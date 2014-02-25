$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "alle_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "alle_api"
  s.version     = AlleApi::VERSION
  s.authors       = ["Wojtek Majewski"]
  s.email         = ["jumski@gmail.com"]
  s.homepage    = "http://webmandala.com"
  s.summary       = %q{Allegro WebAPI Rails Engine}
  s.description   = %q{Opinionated Rails Engine that helps with Allegro SOAP sadness}
  s.files = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency 'virtus', '~> 0.5'
  s.add_dependency 'redis-namespace', '~> 1.0'
  s.add_dependency 'redis-objects', '~> 0.6'
  s.add_dependency 'savon', '~> 1.1'
  s.add_dependency 'hashie', '~> 1.2'
  s.add_dependency 'ancestry', '~> 1.2'
  s.add_dependency 'ruby-progressbar', '0.0.10'
  s.add_dependency 'workflow', '~> 0.8.7'
  s.add_dependency 'sidekiq', '2.13.1'
  s.add_dependency 'sidekiq-failures'
  s.add_dependency 'sidekiq-unique-jobs'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-rails'
  # s.add_development_dependency 'pry-debugger'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'fivemat'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'virtus-rspec'
  s.add_development_dependency 'mock_redis'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'mysql2'
end

$: << File.expand_path(File.dirname(__FILE__))

unless ENV['SIMPLE_COV'].nil?
  require 'simplecov'
  SimpleCov.start
end

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec'
require 'rspec/rails'
require 'rails/test_help'
require 'shoulda/matchers'
require 'factory_girl_rails'
require_relative 'dummy/spec/factories/dummy_auctionables'
require 'timecop'
require 'pry'
require 'sidekiq/testing'
require 'alle_api'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.mock_with :mocha
  config.use_transactional_fixtures = false
  config.use_transactional_examples = false
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.include FactoryGirl::Syntax::Methods
  config.filter_run_excluding slow: true, http: true

  config.before(:suite) { DatabaseCleaner.clean_with :truncation }
  config.before(:each)  { DatabaseCleaner.strategy = :transaction }
  config.before(:each)  { DatabaseCleaner.start }
  config.after(:each)   { DatabaseCleaner.clean }
end

Rails.backtrace_cleaner.remove_silencers!

paths = ['config/routes.rb'] +
        Dir['app/**/*.rb'] +
        Dir['spec/shared/**/*.rb'] +
        Dir['spec/support/**/*.rb']
paths.each { |path|
  require File.expand_path(File.dirname(__FILE__) + '/../' + path)
}

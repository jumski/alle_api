require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = 'spec/support/cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { :record => :new_episodes }

  config.filter_sensitive_data('{webapi_key}')      { AlleApi.config.webapi_key }
  config.filter_sensitive_data('{webapi_login}')    { AlleApi.config.login }
  config.filter_sensitive_data('{webapi_password}') { AlleApi.config.password }

  if ENV['VCR_DEBUG'].present?
    config.debug_logger = File.open('log/vcr.log', 'w')
  end
end

RSpec.configure do |config|
  # wrap all specs with WSDL cassette
  config.around(:each) do |example|
    cassette = if AlleApi.config.sandbox
                 :authenticate_and_update_sandbox
               else
                 :authenticate_and_update_production
               end

    VCR.use_cassette(cassette, match_requests_on: [:uri, :body]) do
      example.run
    end
  end

  config.around(:each) do |example|
    if example.metadata[:vcr].present?
      cassette = example.metadata[:vcr]
      options = {match_requests_on: [:uri, :body]}

      VCR.use_cassette(cassette, options) { example.run }
    else
      example.run
    end
  end
end

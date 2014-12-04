require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = 'spec/support/cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { :record => :once }

  if ENV['VCR_DEBUG'].present?
    config.debug_logger = File.open('log/vcr.log', 'w')
  end
end

RSpec.configure do |config|
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

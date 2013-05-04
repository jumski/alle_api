require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = 'spec/support/cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { :record => :once }
end

RSpec.configure do |config|
  config.around(:each) do |example|
    if example.metadata[:vcr].present?
      cassette = example.metadata[:vcr]
      options = {match_requests_on: [:uri, :body]}

      Savon.configure { |c| c.log = false }
      VCR.use_cassette(cassette, options) { example.run }
      Savon.configure { |c| c.log = true }
    else
      example.run
    end
  end
end

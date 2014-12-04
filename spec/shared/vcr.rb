
shared_context 'allow http connections' do

  around do |example|
    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = true
    end

    example.run

    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = false
    end
  end

end

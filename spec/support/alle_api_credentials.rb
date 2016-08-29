# if alle api config is present, get credentials and write to ENV
config_path = ENV.fetch('ALLE_API_CONFIG_PATH')

if File.exist?(config_path)
  YAML.load_file(config_path)[Rails.env].tap do |config|
    ENV['ALLE_API_WEBAPI_KEY'] = config.fetch('webapi_key')
    ENV['ALLE_API_WEBAPI_LOGIN'] = config.fetch('login')
    ENV['ALLE_API_WEBAPI_PASSWORD'] = config.fetch('password')
  end
end

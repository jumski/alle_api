
RSpec.configure do |config|
  config.around(:each) do |example|
    AlleApi::Client.with_silent_output { example.run }
  end
end

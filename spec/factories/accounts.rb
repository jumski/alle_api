# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alle_api_account, aliases: [:account], class: 'AlleApi::Account' do
    sequence(:login) { |n| "somelogin#{n}"}
    password 'somepassword'
    last_processed_event_id 0
    remote_id 777

    trait :real_credentials do
      unless ENV['ALLE_API_CONFIG_PATH']
        raise "Please set ALLE_API_CONFIG_PATH env var!"
      end

      erb = ERB.new(File.read(ENV['ALLE_API_CONFIG_PATH']))
      yaml = YAML::load(erb.result)
      config = Hashie::Mash.new(yaml)[Rails.env]

      login config.login
      password config.password
    end
  end
end

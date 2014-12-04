require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::Authenticate do

  include_examples 'api action', :do_login do

    it_should_behave_like 'simple #request_body' do
      let(:expected_body) do
        { user_login:    client.login,
          user_password: client.password,
          country_code:  AlleApi::Client::COUNTRY_POLAND,
          webapi_key:    client.webapi_key,
          local_version: client.version_key }
      end
    end

    it_should_behave_like 'simple #extract_results' do
      let(:unextracted) do
        { session_handle_part: 'handle' }
      end

      let(:expected) { 'handle' }
    end
  end
end

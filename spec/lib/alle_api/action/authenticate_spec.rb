require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::Authenticate do

  include_examples 'api action', :do_login do

    it_implements 'simple #request_body' do
      let(:expected_body) do
        { 'user-login'    => client.login,
          'user-password' => client.password,
          'country-code'  => AlleApi::Client::COUNTRY_POLAND,
          'webapi-key'    => client.webapi_key,
          'local-version' => client.version_key }
      end
    end

    it_implements 'simple #extract_results' do
      let(:unextracted) do
        { session_handle_part: 'handle' }
      end

      let(:expected) { 'handle' }
    end
  end
end

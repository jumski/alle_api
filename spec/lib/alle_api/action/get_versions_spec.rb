require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetVersions do

  include_examples 'api action', :do_query_all_sys_status do

    it_implements 'simple #request_body' do
      let(:expected_body) do
        { 'country-id' => client.country_id,
          'webapi-key' => client.webapi_key }
      end
    end

    it_implements 'simple #extract_results' do
      let(:unextracted) do
        versions = [
          { country_id: client.country_id.to_s,
            ver_key: '1234',
            cats_version: '1.0',
            form_sell_version: '1.1' },
          { country_id: '666',
            ver_key: '4321',
            cats_version: '2.0',
            form_sell_version: '2.1' }
        ]

        { sys_country_status: {item: versions} }
      end

      let(:expected) do
        { country_id: client.country_id,
          version_key: '1234',
          categories_tree: '1.0',
          fields: '1.1' }
      end
    end

    describe 'real http requests', vcr: 'get_versions' do
      include_context 'real api client'

      it 'properly parses returned versions' do
        versions = api.get_versions

        expect(versions).to be_a Hash

        expect(versions[:version_key]).to eq("14242869")
        expect(versions[:categories_tree]).to eq("1.0.99")
        expect(versions[:fields]).to eq("1.1.37")
      end
    end

  end



end

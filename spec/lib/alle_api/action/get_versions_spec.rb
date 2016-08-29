require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetVersions do

  include_examples 'api action', :do_query_all_sys_status do

    it_should_behave_like 'simple #request_body' do
      let(:expected_body) do
        { country_id: client.country_id,
          webapi_key: client.webapi_key }
      end
    end

    it_should_behave_like 'simple #extract_results' do
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

        expect(versions.fetch(:version_key).to_i).to be > 0
        expect(versions.fetch(:categories_tree)).to match /\d+\.\d+\.\d+/
        expect(versions.fetch(:fields)).to match /\d+\.\d+\.\d+/
      end
    end

  end



end

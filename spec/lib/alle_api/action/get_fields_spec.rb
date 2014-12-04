require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetFields do

  include_examples 'api action', :do_get_sell_form_fields_ext do

    it_should_behave_like 'simple #request_body' do
      let(:expected_body) do
        { webapi_key: client.webapi_key, country_code:  client.country_id }
      end
    end

    it_should_behave_like '#extract_results using wrapper' do
      let(:wrapper_klass) { AlleApi::Wrapper::Field }

      it "#extract_items returns proper nested hash" do
        nested = { sell_form_fields: { item: 'value' } }

        expect(subject.extract_items(nested)).to eq('value')
      end
    end

  end

end

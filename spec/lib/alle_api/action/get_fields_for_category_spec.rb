require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetFieldsForCategory do

  include_examples 'api action', :do_get_sell_form_fields_for_category do

    it_implements 'simple #request_body' do
      let(:actual_body) { subject.request_body('7') }

      let(:expected_body) do
        { 'webapi-key' => client.webapi_key,
          'country-id' => client.country_id,
          'category-id' => 7 }
      end
    end

    it_implements '#extract_results using wrapper' do
      let(:wrapper_klass) { AlleApi::Wrapper::Field }

      it "#extract_items returns proper nested hash" do
        nested = { sell_form_fields_for_category:
                   { sell_form_fields_list:
                     { item: 'value' } } }

        expect(subject.extract_items(nested)).to eq('value')
      end
    end

  end
end

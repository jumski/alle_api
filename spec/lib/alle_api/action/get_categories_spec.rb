
require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetCategories do
  include_examples 'api action', :do_get_cats_data do

    it_implements 'simple #request_body' do
      let(:expected_body) do
        { "country-id"    => client.country_id,
          "local-version" => client.version_key,
          "webapi-key"    => client.webapi_key }
      end
    end

    describe '#extract_results' do
      include_context "categories from :do_get_cats_data"
      include_context "result from :do_get_cats_data"

      let(:unextracted) { cats_list }

      let(:expected) do
        [
          { name: category_one[:cat_name].to_s,
            id:   category_one[:cat_id].to_i,
            parent_id: category_one[:cat_parent].to_i,
            position:  category_one[:cat_position].to_i },
          { name: category_two[:cat_name].to_s,
            id:   category_two[:cat_id].to_i,
            parent_id: category_two[:cat_parent].to_i,
            position:  category_two[:cat_position].to_i },
        ]

      end

    end

  end




end

require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetPostBuyFormsForSellers do

  include_examples 'api action', :do_get_post_buy_forms_data_for_sellers do
    let(:actual_body) { subject.request_body(ids) }

    it '#validate! raises an exception when ids are empty' do
      expect {
        subject.validate!([])
      }.to raise_error(/Please provide some ids/)
    end

    it_should_behave_like 'simple #request_body' do
      let(:ids) { [1, 2, 3] }
      let(:expected_body) do
        {
          session_id: client.session_handle,
          transactions_ids_array: { item: ids }
        }
      end
    end

    it_should_behave_like '#extract_results using wrapper' do
      let(:wrapper_klass) { AlleApi::Wrapper::PostBuyForm }
    end

  end

end

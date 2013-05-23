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

    it_implements 'simple #request_body' do
      let(:ids) { [1, 2, 3] }
      let(:expected_body) do
        { 'session-id' => client.session_handle,
          'transactions-ids-array' => {
            'transactions-ids-array' => ids
          }
        }
      end
    end

    it_implements '#extract_results using wrapper' do
      let(:wrapper_klass) { AlleApi::Wrapper::PostBuyForm }
    end

  end

end

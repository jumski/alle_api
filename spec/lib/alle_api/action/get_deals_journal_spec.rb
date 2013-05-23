require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetDealsJournal do

  include_examples 'api action', :do_get_site_journal_deals do
    let(:actual_body) { subject.request_body(starting_point) }

    context 'when starting point is provided' do
      let(:starting_point) { 123 }

      it_implements 'simple #request_body' do
        let(:expected_body) do
          { 'session-id' => client.session_handle,
            'journal-start' => 123 }
        end
      end
    end

    context 'when starting point is not provided' do
      let(:starting_point) { nil }

      it_implements 'simple #request_body' do
        let(:expected_body) do
          { 'session-id' => client.session_handle,
            'journal-start' => starting_point }
        end
      end
    end

    it_implements '#extract_results using wrapper' do
      let(:wrapper_klass) { AlleApi::Wrapper::DealEvent }
    end

  end

end

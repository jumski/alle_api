require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetDealsJournal do

  include_examples 'api action', :do_get_site_journal_deals do
    let(:actual_body) { subject.request_body(starting_point) }

    context 'when starting point is provided' do
      let(:starting_point) { 123 }

      it_should_behave_like 'simple #request_body' do
        let(:expected_body) do
          { session_id: client.session_handle, journal_start: 123 }
        end
      end
    end

    context 'when starting point is not provided' do
      let(:starting_point) { nil }

      it_should_behave_like 'simple #request_body' do
        let(:expected_body) do
          { session_id: client.session_handle, journal_start: starting_point }
        end
      end
    end

    it_should_behave_like '#extract_results using wrapper' do
      let(:wrapper_klass) { AlleApi::Wrapper::DealEvent }
    end
  end

end

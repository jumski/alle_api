
require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetJournal do

  include_examples 'api action', :do_get_site_journal do
    let(:actual_body) { subject.request_body(starting_point) }

    context 'when starting point is provided' do
      let(:starting_point) { 123 }

      it_should_behave_like 'simple #request_body' do
        let(:expected_body) do
          { session_handle: client.session_handle,
            starting_point: 123,
            info_type:      0 }
        end
      end
    end

    context 'when starting point is not provided' do
      let(:starting_point) { nil }

      it_should_behave_like 'simple #request_body' do
        let(:expected_body) do
          { session_handle: client.session_handle,
            starting_point: starting_point,
            info_type:      0 }
        end
      end
    end

    it_should_behave_like '#extract_results using wrapper' do
      let(:wrapper_klass) { AlleApi::Wrapper::Event }

      it "#extract_items returns proper nested hash" do
        nested = { site_journal_array: { item: 'value' } }

        expect(subject.extract_items(nested)).to eq('value')
      end
    end
  end
end

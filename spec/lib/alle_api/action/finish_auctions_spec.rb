require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::FinishAuctions do

  include_examples 'api action', :do_finish_items do

    it_implements 'simple #request_body' do
      let(:actual_body) { subject.request_body([23, 5]) }

      let(:expected_body) do
        { 'session-handle' => client.session_handle,
          'finish-items-list' => {
            'finish-items-list' => [
              { 'finish-item-id'         => 23,
                'finish-cancel-all-bids' => 0,
                'finish-cancel-reason'   => '' },
              { 'finish-item-id'         => 5,
                'finish-cancel-all-bids' => 0,
                'finish-cancel-reason'   => '' },
            ]
          }
        }
      end
    end

    it '#validate! raises validation error when there are no auctions to finish' do
      expect {
        subject.validate!([])
      }.to raise_error(AlleApi::Action::ValidationError,
                       /Please provide remote ids/)
    end

    it '#validate! does not raise an exception when passed some auction ids' do
      expect {
        subject.validate!([1,2])
      }.to_not raise_error
    end

    it '#validate! raises validation error when passed more than 25 ids' do
      expect{
        subject.validate!( 26.times.map { 1 } )
      }.to raise_error(AlleApi::Action::ValidationError,
                       /Cannot finish more than 25 auctions at once/)

    end

    describe '#extract_results' do
      let(:unextracted) do
        { finish_items_succeed: { item: items },
          finish_items_failed: { } }
      end

      let(:expected) do
        { finished: remote_ids, failed: [] }
      end

      context 'when finishing only one auction' do
        # when we've got only 1 item, it is not returned in an array
        let(:items) { remote_ids.first.to_s }
        let(:remote_ids) { [1] }

        it_implements 'simple #extract_results'
      end

      context 'when finishing more than one auction' do
        # when we finish more than 1 auction, we've got an array of ids in return
        let(:items) { remote_ids.map(&:to_s) }
        let(:remote_ids) { [1, 2] }

        it_implements 'simple #extract_results'
      end
    end

  end

end

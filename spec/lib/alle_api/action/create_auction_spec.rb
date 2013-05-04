
require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::CreateAuction do
  include_examples 'api action', :do_new_auction_ext do

    it_implements 'simple #request_body' do
      let(:actual_body) do
        auction = stub(to_fields_array: [1,2,3])

        subject.request_body(auction)
      end

      let(:expected_body) do
        { 'session-handle' => client.session_handle,
          'fields' => {'fields' => [1,2,3]} }
      end
    end

    it_implements 'simple #extract_results' do
      let(:unextracted) { [1, 2, 3] }
      let(:expected)    { unextracted }
    end

    it '#validate! raises an exception when auction is invalid' do
      auction = stub(valid?: false)

      expect {
        subject.validate!(auction)
      }.to raise_error(/Invalid auction/)
    end

    it '#validate! does not raise an exception if passing valid auction' do
      auction = stub(valid?: true)

      expect {
        subject.validate!(auction)
      }.to_not raise_error
    end
  end

end

require 'spec_helper'

describe AlleApi::PostBuyForm do
  it { should belong_to :account }
  it { should have_many :deal_events }

  it { should validate_uniqueness_of :remote_id }

  describe "#auction" do
    it 'returns auction of last deal event' do
      fake_auction = stub('Auction')
      subject.stubs(deal_events: [stub(), stub(auction: fake_auction)])

      expect(subject.auction).to eq fake_auction
    end
  end
end

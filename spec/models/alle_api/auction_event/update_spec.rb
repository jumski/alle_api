require 'spec_helper'

describe AlleApi::AuctionEvent::Update do
  subject { create :auction_event_update, auction: auction }
  let(:auction) { build_stubbed :auction }

  it { should be_an AlleApi::AuctionEvent }

  describe '#alter_auction_state' do
    it 'calls #touch on the auction' do
      auction.expects(:touch)

      subject.alter_auction_state
    end
  end
end

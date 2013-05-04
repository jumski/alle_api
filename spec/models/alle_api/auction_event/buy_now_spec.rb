require 'spec_helper'

describe AlleApi::AuctionEvent::BuyNow do
  subject { create :auction_event_buy_now, auction: auction }
  let(:auction) { build_stubbed :auction, :published }

  it { should be_an AlleApi::AuctionEvent }

  describe '#alter_auction_state' do
    it 'calls #end! on the auction' do
      auction.expects(:buy_now!)

      subject.alter_auction_state
    end
  end
end

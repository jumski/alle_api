require 'spec_helper'

describe AlleApi::AuctionEvent::End do
  subject { create :auction_event_end, auction: auction }
  let(:auction) { build_stubbed :auction, :published }

  it { should be_an AlleApi::AuctionEvent }

  describe '#alter_auction_state' do
    it 'calls #end! on the auction' do
      auction.expects(:end!)

      subject.alter_auction_state
    end
  end
end

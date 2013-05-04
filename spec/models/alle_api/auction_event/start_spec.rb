require 'spec_helper'

describe AlleApi::AuctionEvent::Start do
  subject { create :auction_event_start, auction: auction }
  let(:auction) { build_stubbed :auction }

  it { should be_an AlleApi::AuctionEvent }

  describe '#alter_auction_state' do
    it 'does nothing' do
      expect { subject.alter_auction_state }.to_not raise_error
    end
  end
end

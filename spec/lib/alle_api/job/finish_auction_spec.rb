
require 'spec_helper'

describe AlleApi::Job::FinishAuction do

  include_context 'silenced logger'

  before { AlleApi::Account.any_instance.stubs(api: fake_api) }
  subject { described_class.new }
  let(:fake_api) { mock }

  it { should be_a AlleApi::Job::Base }

  context '#perform' do
    context 'when auction is in queued_for_finishing state' do
      let(:auction) { create :auction, :queued_for_finishing, :with_template }
      let(:account) { auction.account }

      it "calls api#finish_auction with remote id" do
        fake_api.expects(:finish_auction).
                 with(auction.remote_id)

        subject.perform auction.id
      end

      it 'ends an auction on success' do
        fake_api.stubs(:finish_auction).returns(true)

        subject.perform auction.id

        expect(auction.reload).to be_ended
      end

      it 'does not ends auction on failure' do
        fake_api.stubs(:finish_auction).returns(false)

        subject.perform auction.id

        expect(auction.reload).to be_queued_for_finishing
      end

      it 'does not change auction state on error (depend on sidekiq retry)' do
        error = ArgumentError.new
        fake_api.stubs(:finish_auction).raises(error)

        expect {
          subject.perform auction.id
        }.to raise_error(error)

        auction.reload.should be_queued_for_finishing
      end

    end

  end

  # ensure we can finish only queued_for_finishing auctions
  %w(ended published).each do |state|
    context "when auction is in #{state} state" do
      let(:auction){ create :auction, state: state }

      it 'raises error' do
        expect {
          subject.perform auction.id
        }.to raise_error(AlleApi::InvalidAuctionForFinishingError)
      end
    end
  end

end


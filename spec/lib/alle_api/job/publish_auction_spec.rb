
require 'spec_helper'

describe AlleApi::Job::PublishAuction do

  include_context 'silenced logger'

  before { AlleApi::Account.any_instance.stubs(api: fake_api) }
  subject { described_class.new }
  let(:fake_api) { mock }

  it { should be_a AlleApi::Job::Base }

  context "#perform" do
    context 'when auction is in queued_for_publication state' do
      let(:auction) { create :auction, :queued_for_publication }
      let(:account) { auction.account }

      it "calls api#create_auction with auction#to_allegro_auction values" do
        AlleApi::Auction.any_instance.stubs(to_allegro_auction: 'omg hax')
        fake_api.expects(:create_auction).
                 with(auction.to_allegro_auction).
                 returns(item_id: 23)

        subject.perform auction.id
      end

      it 'publishes an auction on success' do
        fake_api.stubs(:create_auction).returns(item_id: 23)

        subject.perform auction.id

        auction.reload.remote_id.should == 23
        auction.should be_published
      end

      it 'does not change auction state on error (depend on sidekiq retry)' do
        error = ArgumentError.new
        fake_api.stubs(:create_auction).raises(error)

        expect {
          subject.perform auction.id
        }.to raise_error(error)

        auction.reload.should be_queued_for_publication
      end

    end

    # ensure we can publish only queued_for_publication auctions
    %w(created published).each do |state|
      context "when auction is in #{state} state" do
        let(:auction){ create :auction, state: state }

        it 'raises error' do
          expect {
            subject.perform auction.id
          }.to raise_error(AlleApi::InvalidAuctionForPublicationError)
        end
      end
    end

  end

end

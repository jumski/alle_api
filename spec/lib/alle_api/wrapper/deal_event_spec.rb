require 'spec_helper'

describe AlleApi::Wrapper::DealEvent do

  describe "#create_if_missing" do
    let(:wrapper) { build :new_deal_wrapper }
    let(:account) { create :account }
    let(:auction) do
      create :auction, :published,
        account: account, remote_id: wrapper.remote_auction_id
    end

    def create_event!
      auction # trigger create
      wrapper.create_if_missing
    end
    subject { create_event! }

    it 'creates new event for first time' do
      expect {
        subject
      }.to change(AlleApi::DealEvent::NewDeal, :count).to(1)
    end

    it 'is idempotent' do
      expect {
        create_event!
        create_event!
      }.to change(AlleApi::DealEvent::NewDeal, :count).to(1)
    end

    its(:auction) { should eq auction }

    attrs = described_class::ATTRIBUTE_NAME_TRANSLATION.values - [:kind]
    attrs.each do |attr|
      its(attr) { should eq wrapper.send(attr) }
    end
  end

  describe "integration test" do
    include_context 'authenticated and updated api client'

    context "given response with events", vcr: 'do_get_deals_journal_with_items' do
      subject(:deal_events) { api.get_deals_journal 123 }

      xit 'exposes proper attributes for all deals' do
        deal_events.each do |deal_event|
          expect(deal_event).to be_a AlleApi::Wrapper::DealEvent
          expect(deal_event.remote_id).to be > 0
          expect(deal_event.occured_at).to be_a DateTime
          expect(deal_event.occured_at).to be < Time.now
          expect(deal_event.remote_deal_id).to be > 0
          expect(deal_event.remote_seller_id).to be > 0
          expect(deal_event.remote_auction_id).to be > 0
          expect(deal_event.remote_buyer_id).to be > 0
          expect(deal_event.quantity).to eq 1
        end
      end

      xit 'has proper model_klass' do
        expect(deal_events[0].model_klass).to eq AlleApi::DealEvent::NewDeal
        expect(deal_events[1].model_klass).to eq AlleApi::DealEvent::NewTransaction
        expect(deal_events[2].model_klass).to eq AlleApi::DealEvent::FinishTransaction
      end

      xit 'has proper transaction_id' do
        expect(deal_events[0].remote_transaction_id).to eq 0
        expect(deal_events[1].remote_transaction_id).to be > 0
        expect(deal_events[2].remote_transaction_id).to be > 0
      end
    end

    context "given response without events", vcr: 'do_get_deals_journal_without_items' do
      subject(:deal_events) { api.get_deals_journal 1420594563 }

      it 'parses returned events' do
        expect(deal_events).to eq []
      end
    end
  end


end

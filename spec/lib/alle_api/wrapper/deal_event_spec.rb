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

  describe "integration test", vcr: 'do_get_deals_journal' do
    include_context 'authenticated and updated api client'
    before { @wrapped = api.get_deals_journal }

    context "wraps new deal event" do
      subject { @wrapped[0] }

      it 'exposes proper attributes' do
        expect(subject).to be_a AlleApi::Wrapper::DealEvent
        expect(subject.remote_id).to eq 775599262
        expect(subject.model_klass).to eq AlleApi::DealEvent::NewDeal
        expect(subject.occured_at).to eq Time.at 1369042031
        expect(subject.remote_deal_id).to eq 896009896
        expect(subject.remote_transaction_id).to eq 0
        expect(subject.remote_seller_id).to eq 2783112
        expect(subject.remote_auction_id).to eq 3263045863
        expect(subject.remote_buyer_id).to eq 5697909
        expect(subject.quantity).to eq 1
      end
    end

    context "wraps new transaction event" do
      subject { @wrapped[1] }

      it 'exposes proper attributes' do
        expect(subject).to be_a AlleApi::Wrapper::DealEvent
        expect(subject.remote_id).to eq 775601305
        expect(subject.model_klass).to eq AlleApi::DealEvent::NewTransaction
        expect(subject.occured_at).to eq Time.at 1369042118
        expect(subject.remote_deal_id).to eq 896009896
        expect(subject.remote_transaction_id).to eq 243241703
        expect(subject.remote_seller_id).to eq 2783112
        expect(subject.remote_auction_id).to eq 3263045863
        expect(subject.remote_buyer_id).to eq 5697909
        expect(subject.quantity).to eq 1
      end
    end
  end

end

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

      it { should be_a AlleApi::Wrapper::DealEvent }
      its(:remote_id) { should eq 775599262 }
      its(:model_klass) { should eq AlleApi::DealEvent::NewDeal }
      its(:occured_at) { should eq Time.at 1369042031 }
      its(:remote_deal_id) { should eq 896009896 }
      its(:remote_transaction_id) { should eq 0 }
      its(:remote_seller_id) { should eq 2783112 }
      its(:remote_auction_id) { should eq 3263045863 }
      its(:remote_buyer_id) { should eq 5697909 }
      its(:quantity) { should eq 1 }
    end

    context "wraps new transaction event" do
      subject { @wrapped[1] }

      it { should be_a AlleApi::Wrapper::DealEvent }
      its(:remote_id) { should eq 775601305 }
      its(:model_klass) { should eq AlleApi::DealEvent::NewTransaction }
      its(:occured_at) { should eq Time.at 1369042118 }
      its(:remote_deal_id) { should eq 896009896 }
      its(:remote_transaction_id) { should eq 243241703 }
      its(:remote_seller_id) { should eq 2783112 }
      its(:remote_auction_id) { should eq 3263045863 }
      its(:remote_buyer_id) { should eq 5697909 }
      its(:quantity) { should eq 1 }
    end
  end

end

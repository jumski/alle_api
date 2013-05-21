
require 'spec_helper'

describe AlleApi::Wrapper::PostBuyForm do

  # describe "#create_deal_event" do
  #   let(:wrapper) { build :new_deal_wrapper }
  #   let(:account) { create :account }
  #   let(:auction) do
  #     create :auction, :published,
  #       account: account, remote_id: wrapper.remote_auction_id
  #   end

  #   def create_event!
  #     auction # trigger create
  #     wrapper.create_deal_event(account)
  #   end
  #   subject { create_event! }

  #   it 'creates new event for first time' do
  #     expect {
  #       subject
  #     }.to change(AlleApi::DealEvent::NewDeal, :count).to(1)
  #   end

  #   it 'is idempotent' do
  #     expect {
  #       create_event!
  #       create_event!
  #     }.to change(AlleApi::DealEvent::NewDeal, :count).to(1)
  #   end

  #   its(:auction) { should eq auction }

  #   attrs = described_class::ATTRIBUTE_NAME_TRANSLATION.values - [:kind]
  #   attrs.each do |attr|
  #     its(attr) { should eq wrapper.send(attr) }
  #   end
  # end
end

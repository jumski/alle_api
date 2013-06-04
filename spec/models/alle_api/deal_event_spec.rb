require 'spec_helper'

describe AlleApi::DealEvent do
  it { should belong_to :auction }
  it { should belong_to :account }
  it { should belong_to :post_buy_form }

  AlleApi::DealEvent::REQUIRED.each do |attr|
    it { should validate_presence_of attr }
  end

  AlleApi::DealEvent::NUMERICAL.each do |attr|
    it { should validate_numericality_of attr }
  end

  context "with some deal events" do
    before do
      @new_deal = create :new_deal
      @new_transaction = create :new_transaction
      @lacking_post_buy_form = create :fresh_new_transaction
    end

    describe ".lacking_post_buy_form", :sql do
      subject { described_class.lacking_post_buy_form }

      it { should include @lacking_post_buy_form }
      it { should_not include @new_transaction }
      it { should_not include @new_deal }
    end

    describe ".missing_transaction_ids" do
      subject { described_class.missing_transaction_ids }

      it { should eq [@lacking_post_buy_form.remote_transaction_id] }
    end
  end

  it 'steals account from auction on create' do
    account = create :account
    auction = create :auction, account: account
    deal_event = create :new_deal, auction: auction

    expect(deal_event.account).to eq account
  end
end

require 'spec_helper'

describe AlleApi::DealEvent do
  it { should belong_to :auction }
  it { should belong_to :post_buy_form }

  AlleApi::DealEvent::REQUIRED.each do |attr|
    it { should validate_presence_of attr }
  end

  AlleApi::DealEvent::NUMERICAL.each do |attr|
    it { should validate_numericality_of attr }
  end

  describe AlleApi::DealEvent::NewTransaction do
    context "with some deal events" do
      before do
        @new_deal = create :new_deal
        @new_transaction = create :new_transaction
        @lacking_post_buy_form = create :fresh_new_transaction
      end

      describe ".lacking_post_buy_form", :sql do
        subject { AlleApi::DealEvent::NewTransaction.lacking_post_buy_form }

        it { should include @lacking_post_buy_form }
        it { should_not include @new_transaction }
        it { should_not include @new_deal }
      end

      describe ".missing_transaction_ids" do
        subject { AlleApi::DealEvent::NewTransaction.missing_transaction_ids }

        it { should eq [@lacking_post_buy_form.remote_transaction_id] }
      end
    end
  end
end

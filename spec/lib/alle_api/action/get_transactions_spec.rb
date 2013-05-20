require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetTransactions do

  include_examples 'api action', :do_get_post_buy_forms_data_for_sellers do
    let(:actual_body) { subject.request_body(ids) }

    # it '#validate! raises an exception when ids are empty' do
    #   expect {
    #     subject.validate!([])
    #   }.to raise_error(/Please provide some ids/)
    # end

    # it_implements 'simple #request_body' do
    #   let(:ids) { [1, 2, 3] }
    #   let(:expected_body) do
    #     { 'session-id' => client.session_handle,
    #       'transactions-ids-array' => ids }
    #   end
    # end

    describe "uses wrapper", vcr: 'do_get_post_buy_forms_data_for_sellers', :hax => true do
      include_context 'real api client'

      before do
        account.utility = true
        account.save!
        AlleApi::Helper::Versions.new.update_version_of(:version_key)
        AlleApi::Job::Authenticate.new.perform(account.id)
        deal_events = api.get_deals_journal
        ids = deal_events.map(&:remote_transaction_id)
        @wrapped = api.get_transactions ids.select{|id| id > 0}
      end

      context "wraps transaction" do
        subject { @wrapped[0] }

        it { should be_a AlleApi::Wrapper::PostBuyForm }
        its(:remote_id) { should eq 243241703 }
        # its(:model_klass) { should eq AlleApi::PostBuyForm }
        its(:source) { should eq subject }
      end

      # context "wraps new transaction event" do
      #   subject { @wrapped[1] }

      #   it { should be_a AlleApi::Wrapper::DealEvent }
      #   its(:remote_id) { should eq 775601305 }
      #   its(:model_klass) { should eq AlleApi::DealEvent::NewTransaction }
      #   its(:occured_at) { should eq Time.at 1369042118 }
      #   its(:remote_deal_id) { should eq 896009896 }
      #   its(:remote_transaction_id) { should eq 243241703 }
      #   its(:remote_seller_id) { should eq 2783112 }
      #   its(:remote_auction_id) { should eq 3263045863 }
      #   its(:remote_buyer_id) { should eq 5697909 }
      #   its(:quantity) { should eq 1 }
      # end
    end

  end

end

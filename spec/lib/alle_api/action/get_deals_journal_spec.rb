require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetDealsJournal do

  include_examples 'api action', :do_get_site_journal_deals do
    let(:actual_body) { subject.request_body(starting_point) }

    context 'when starting point is provided' do
      let(:starting_point) { 123 }

      it_implements 'simple #request_body' do
        let(:expected_body) do
          { 'session-id' => client.session_handle,
            'journal-start' => 123 }
        end
      end
    end

    context 'when starting point is not provided' do
      let(:starting_point) { nil }

      it_implements 'simple #request_body' do
        let(:expected_body) do
          { 'session-id' => client.session_handle,
            'journal-start' => starting_point }
        end
      end
    end

    describe "uses wrapper", vcr: 'do_get_deals_journal' do
      include_context 'authenticated and updated api client'
      before { @wrapped = api.get_deals_journal }

      # context "wraps new deal event" do
      #   subject { @wrapped[0] }

      #   it { should be_a AlleApi::Wrapper::DealEvent }
      #   its(:remote_id) { should eq 775599262 }
      #   its(:model_klass) { should eq AlleApi::DealEvent::NewDeal }
      #   its(:occured_at) { should eq Time.at 1369042031 }
      #   its(:remote_deal_id) { should eq 896009896 }
      #   its(:remote_transaction_id) { should eq 0 }
      #   its(:remote_seller_id) { should eq 2783112 }
      #   its(:remote_auction_id) { should eq 3263045863 }
      #   its(:remote_buyer_id) { should eq 5697909 }
      #   its(:quantity) { should eq 1 }
      # end

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

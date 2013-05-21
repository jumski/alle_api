# encoding: utf-8
require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetPostBuyFormsForSellers do

  include_examples 'api action', :do_get_post_buy_forms_data_for_sellers do
    # let(:actual_body) { subject.request_body(ids) }

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
      include_context 'authenticated and updated api client'

      before do
        deal_events = api.get_deals_journal
        ids = deal_events.map(&:remote_transaction_id)
        @wrapped = api.get_post_buy_forms_for_sellers ids.select{|id| id > 0}
      end

      context "wraps transaction" do
        # payu payed fully
        subject { @wrapped[1] }

        # specify { binding.pry }
        it { should be_a AlleApi::Wrapper::PostBuyForm }

        its(:remote_id) { should eq 243626480 }
        its(:source) { should eq subject }
        its(:shipment_id) { should eq 1 }

        its(:buyer_id) { should eq 5697909 }
        its(:buyer_login) { should eq 'Yumm' }
        its(:buyer_email) { should eq 'jumski+allegro@gmail.com'  }
        its(:invoice_requested) { should be_false }
        its(:message_to_seller) { should eq 'siema gudi payu full' }

        its(:amount) { should eq 2.0 }
        its(:postage_amount) { should eq 1.0 }
        its(:payment_amount) { should eq 2 }

        its(:payment_type) { should eq 'co' }
        its(:payment_id) { should eq 318277336 }
        its(:payment_status) { should eq 'Zakończona' }
        its(:payment_created_at) { should eq DateTime.parse('2013-05-21 13:12:40') }
        its(:payment_received_at) { should eq DateTime.parse('2013-05-21 13:12:40') }
        its(:payment_cancelled_at) { should be_nil }

        its(:shipment_address) { should be_a AlleApi::Wrapper::ShipmentAddress }
        describe 'shipment address' do
          subject { @wrapped[1].shipment_address }

          # specify { binding.pry }
          its(:country_id) { should eq 1 }
          its(:country) { should eq 'Polska' }
          its(:address_1) { should eq "os. Tysiąclecia 32/14" }
          its(:zipcode) { should eq '31-610' }
          its(:city) { should eq 'Kraków' }
          its(:full_name) { should eq 'Wojciech Majewski' }
          its(:company) { should be_nil  }
          its(:phone_number) { should eq '883091610' }
          its(:created_at) { should eq DateTime.parse("2013-05-21 13:09:19") }
          its(:type) { should eq 1 }
        end
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

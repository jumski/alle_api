# encoding: utf-8
require 'spec_helper'
require 'shared/wrapper'

describe AlleApi::Wrapper::PostBuyForm do
  extend WrapperMacros

  converts_nil_hash_to_nil_for :message_to_seller

  describe "uses wrapper", vcr: 'do_get_post_buy_forms_data_for_sellers' do
    include_context 'real api client'

    before(:all) do
      DatabaseCleaner.clean_with :truncation
      # Savon.configure { |c| c.log = false }
      VCR.insert_cassette :do_get_post_buy_forms_data_for_sellers

      account.utility = true
      account.save!
      AlleApi::Helper::Versions.new.update(:version_key)
      AlleApi::Job::Authenticate.new.perform(account.id)

      @auction = create :auction, remote_id: 4762519063

      deal_events = api.get_deals_journal 123
      ids = deal_events.map(&:remote_transaction_id)
      @wrapped = api.get_post_buy_forms_for_sellers ids.select{|id| id > 0}
    end
    after(:all) do
      DatabaseCleaner.clean_with :truncation
      VCR.eject_cassette
      # Savon.configure { |c| c.log = true }
    end

    context "integration test" do
      # payu payed fully
      subject { @wrapped[1] }

      # specify { binding.pry }
      it { should be_a AlleApi::Wrapper::PostBuyForm }

      its(:remote_id) { should eq 392693461 }
      its(:source) { should eq subject }
      its(:shipment_id) { should eq 8 }

      its(:buyer_id) { should eq 38552453 }
      its(:buyer_login) { should eq "Client:38552453" }
      its(:buyer_email) { should eq 'jumski@gmail.com'  }
      its(:invoice_requested) { should be_false }
      its(:message_to_seller) { should eq 'hej flaki !' }

      its(:amount) { should eq 6.43 }
      its(:postage_amount) { should eq 1.2 }
      its(:payment_amount) { should eq 6.43 }

      its(:payment_id) { should eq 392693461 }
      its(:payment_created_at) { should eq DateTime.parse('2014-12-04 17:37:36') }
      its(:payment_received_at) { should eq DateTime.parse('2014-12-04 17:37:36') }
      its(:payment_cancelled_at) { should be_nil }

      context "when only 1 item is present" do
        before do
          expect(subject.source[:post_buy_form_items][:item]).to be_a Hash
        end

        its(:remote_auction_ids) { should eq [@auction.remote_id] }
      end

      context 'when more than 1 item is present', :zomg do
        before do
          item = subject.source[:post_buy_form_items][:item]
          item2 = item.dup
          item2[:post_buy_form_it_id] = 999

          subject.source[:post_buy_form_items][:item] = [item, item2]
        end

        its(:remote_auction_ids) { should eq [@auction.remote_id, 999] }
      end

      context "when payment_type is set to co" do
        before { subject.payment_type = 'co' }
        its(:payment_type) { should eq :payu_checkout }
      end

      context "when payment_type is set to co" do
        before { subject.payment_type = 'ai' }
        its(:payment_type) { should eq :payu_installments }
      end

      context "when payment_type is set to co" do
        before { subject.payment_type = 'collect_on_delivery' }
        its(:payment_type) { should eq :collect_on_delivery }
      end

      context "when payment_status is Rozpoczęta" do
        before { subject.payment_status = 'Rozpoczęta' }
        its(:payment_status) { should eq :started }
      end

      context "when payment_status is Anulowana" do
        before { subject.payment_status = 'Anulowana' }
        its(:payment_status) { should eq :cancelled }
      end

      context "when payment_status is Odrzucona" do
        before { subject.payment_status = 'Odrzucona' }
        its(:payment_status) { should eq :rejected }
      end

      context "when payment_status is Zakończona" do
        before { subject.payment_status = 'Zakończona' }
        its(:payment_status) { should eq :finished }
      end

      context "when payment_status is Wycofana", :xxx do
        before { subject.payment_status = 'Wycofana' }
        its(:payment_status) { should eq :withdrawn }
      end

      its(:shipment_address) { should be_a AlleApi::Wrapper::ShipmentAddress }
      describe 'shipment address' do
        subject { @wrapped[1].shipment_address }

        its(:country_id) { should eq 1 }
        its(:country) { should eq 'Polska' }
        its(:address_1) { should eq "Adres 23`" }
        its(:zipcode) { should eq '33-222' }
        its(:city) { should eq 'Kraków' }
        its(:full_name) { should eq 'Www Mwww' }
        its(:company_name) { should be_nil }
        its(:phone_number) { should eq '123456789' }
        its(:created_at) { should eq DateTime.parse("2014-12-04 17:35:41") }
        its(:type) { should eq 0 }
      end
    end

    context "creates records" do
      let(:wrapped) { @wrapped[1] }
      subject { do_create! }

      def do_create!
        wrapped.create_if_missing(account).reload
      end

      it { should be_a AlleApi::PostBuyForm }
      it { should be_valid }
      it { should be_persisted }
      its(:account) { should eq account }

      its(:remote_id) { should eq wrapped.remote_id }
      its(:source) { should eq wrapped.source }
      its(:shipment_id) { should eq wrapped.shipment_id }

      its(:buyer_id) { should eq wrapped.buyer_id }
      its(:buyer_login) { should eq wrapped.buyer_login }
      its(:buyer_email) { should eq wrapped.buyer_email  }
      its(:invoice_requested) { should eq wrapped.invoice_requested }
      its(:message_to_seller) { should eq wrapped.message_to_seller }

      its(:amount) { should eq wrapped.amount }
      its(:postage_amount) { should eq wrapped.postage_amount }
      its(:payment_amount) { should eq wrapped.payment_amount }

      its(:payment_type) { should eq wrapped.payment_type.to_s }
      its(:payment_id) { should eq wrapped.payment_id }
      its(:payment_status) { should eq wrapped.payment_status.to_s }
      its(:payment_created_at) { should eq wrapped.payment_created_at }
      its(:payment_received_at) { should eq wrapped.payment_received_at }
      its(:payment_cancelled_at) { should eq wrapped.payment_cancelled_at }

      its(:shipment_address) { should eq wrapped.shipment_address.to_hash }
      its(:auctions) { should eq [@auction] }

      it 'is idempotent' do
        do_create!

        expect { do_create! }.to_not change(AlleApi::PostBuyForm, :count)
      end
    end
  end

end

# encoding: utf-8
require 'spec_helper'

describe AlleApi::Wrapper::PostBuyForm do
  describe "#create_if_missing" do
    # let(:wrapper) { build :new_deal_wrapper }
    # let(:account) { create :account }
    # let(:auction) do
    #   create :auction, :published,
    #     account: account, remote_id: wrapper.remote_auction_id
    # end

    # def create_event!
    #   auction # trigger create
    #   wrapper.create_if_missing(account)
    # end
    # subject { create_event! }

    # it 'creates new event for first time' do
    #   expect {
    #     subject
    #   }.to change(AlleApi::DealEvent::NewDeal, :count).to(1)
    # end

    # it 'is idempotent' do
    #   expect {
    #     create_event!
    #     create_event!
    #   }.to change(AlleApi::DealEvent::NewDeal, :count).to(1)
    # end

    # its(:auction) { should eq auction }

    # attrs = described_class::ATTRIBUTE_NAME_TRANSLATION.values - [:kind]
    # attrs.each do |attr|
    #   its(attr) { should eq wrapper.send(attr) }
    # end
  end

  describe "uses wrapper", vcr: 'do_get_post_buy_forms_data_for_sellers' do
    include_context 'real api client'

    before(:all) do
      DatabaseCleaner.clean
      Savon.configure { |c| c.log = false }
      VCR.insert_cassette :do_get_post_buy_forms_data_for_sellers

      account.utility = true
      account.save!
      AlleApi::Helper::Versions.new.update(:version_key)
      AlleApi::Job::Authenticate.new.perform(account.id)

      deal_events = api.get_deals_journal
      ids = deal_events.map(&:remote_transaction_id)
      @wrapped = api.get_post_buy_forms_for_sellers ids.select{|id| id > 0}
    end
    after(:all) do
      DatabaseCleaner.clean
      VCR.eject_cassette
      Savon.configure { |c| c.log = true }
    end

    context "integration test" do
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

      its(:payment_id) { should eq 318277336 }
      its(:payment_created_at) { should eq DateTime.parse('2013-05-21 13:12:40') }
      its(:payment_received_at) { should eq DateTime.parse('2013-05-21 13:12:40') }
      its(:payment_cancelled_at) { should be_nil }

      context "when only 1 item is present", :zomg do
        before do
          expect(subject.source[:post_buy_form_items][:item]).to be_a Hash
        end

        its(:remote_auction_ids) { should eq [3266166575] }
      end

      context 'when more than 1 item is present', :zomg do
        before do
          item = subject.source[:post_buy_form_items][:item]
          item2 = item.dup
          item2[:post_buy_form_it_id] = 999

          subject.source[:post_buy_form_items][:item] = [item, item2]
        end

        its(:remote_auction_ids) { should eq [3266166575, 999] }
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

    context "creates records" do
      let(:wrapped) { @wrapped[1] }
      def do_create!
        wrapped.create_if_missing(account).reload
      end
      before do
        @auction = create :auction, remote_id: 3266166575
      end
      subject { do_create! }

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

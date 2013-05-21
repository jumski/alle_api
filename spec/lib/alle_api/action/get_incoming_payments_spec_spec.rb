require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetIncomingPayments do

  include_examples 'api action', :do_get_my_incoming_payments do
    let(:args) do
      { buyer_id: 12, auction_id: 13, limit: 5, offset: 20,
        date_from: Date.yesterday, date_to: Date.today }
    end
    let(:expected_body) do
      { 'session-handle'       => client.session_handle,
        'buyer-id'             => args[:buyer_id],
        'item-id'              => args[:auction_id],
        'trans-recv-date-from' => args[:date_from],
        'trans-recv-date-to'   => args[:date_to],
        'trans-page-limit'     => args[:limit],
        'trans-offset'         => args[:offset] }
    end
    let(:actual_body) { subject.request_body(args) }

    describe "#validate!" do
      it "allows passing all filters" do
        expect {
          subject.validate!(expected_body)
        }.to_not raise_error
      end

      optional = %w(
        buyer-id item-id trans-recv-date-from
        trans-recv-date-to trans-page-limit trans-offset
      )
      optional.map(&:to_sym).each do |key|
        it "allows passing nil to #{key}" do
          params = expected_body
          params.delete(key)

          expect {
            subject.validate!(params)
          }.to_not raise_error
        end
      end
    end

    it_implements 'simple #request_body'

    describe "uses wrapper", vcr: 'do_get_my_incoming_payments' do
      include_context 'authenticated and updated api client'

      before { @wrapped = api.get_incoming_payments }

      it "hax" do
        binding.pry
      end
    end

    # context 'when starting point is provided' do
    # end

    # context 'when starting point is not provided' do
    #   let(:starting_point) { nil }

    #   it_implements 'simple #request_body' do
    #     let(:expected_body) do
    #       { 'session-id' => client.session_handle,
    #         'journal-start' => starting_point }
    #     end
    #   end
    # end

    # describe "uses wrapper", vcr: 'get_deals_journal' do
    #   include_context 'real api client'

    #   before do
    #     account.utility = true
    #     account.save!
    #     AlleApi::Helper::Versions.new.update(:version_key)
    #     AlleApi::Job::Authenticate.new.perform(account.id)
    #     @wrapped = api.get_deals_journal
    #   end

    #   context "wraps new deal event" do
    #     subject { @wrapped[0] }

    #     it { should be_a AlleApi::Wrapper::DealEvent }
    #     its(:remote_id) { should eq 775599262 }
    #     its(:model_klass) { should eq AlleApi::DealEvent::NewDeal }
    #     its(:occured_at) { should eq Time.at 1369042031 }
    #     its(:remote_deal_id) { should eq 896009896 }
    #     its(:remote_transaction_id) { should eq 0 }
    #     its(:remote_seller_id) { should eq 2783112 }
    #     its(:remote_auction_id) { should eq 3263045863 }
    #     its(:remote_buyer_id) { should eq 5697909 }
    #     its(:quantity) { should eq 1 }
    #   end

    #   context "wraps new transaction event" do
    #     subject { @wrapped[1] }

    #     it { should be_a AlleApi::Wrapper::DealEvent }
    #     its(:remote_id) { should eq 775601305 }
    #     its(:model_klass) { should eq AlleApi::DealEvent::NewTransaction }
    #     its(:occured_at) { should eq Time.at 1369042118 }
    #     its(:remote_deal_id) { should eq 896009896 }
    #     its(:remote_transaction_id) { should eq 243241703 }
    #     its(:remote_seller_id) { should eq 2783112 }
    #     its(:remote_auction_id) { should eq 3263045863 }
    #     its(:remote_buyer_id) { should eq 5697909 }
    #     its(:quantity) { should eq 1 }
    #   end
    # end

  end

end

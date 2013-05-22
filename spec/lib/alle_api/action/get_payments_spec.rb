# encoding: utf-8
require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetPayments do

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
      before { @wrapped = api.get_payments }
      subject { @wrapped[0] }

      context "wraps" do
        subject { @wrapped[0] }

        # specify { binding.pry }
        it { should be_a AlleApi::Wrapper::Payment }
        its(:source) { should eq subject }
        its(:remote_id) { should eq 243626480 }
        its(:remote_auction_id) { should eq 3266166575 }
        its(:buyer_id) { should eq 5697909 }
        its(:type) { should eq 'co' }
        its(:status) { should eq 'Zakończona' }
        its(:amount) { should eq 2.0 }
        its(:postage_amount) { should eq 1.0 }
        its(:created_at) { should eq Time.at(1369134559).to_datetime }
        its(:received_at) { should eq Time.at(1369134760).to_datetime }
        its(:price) { should eq 1.0 }
        its(:count) { should eq 1 }
        its(:details) { should be_nil }
        its(:completed) { should be_true }
        its(:parent_remote_id) { should be_nil }
      end

      context "creating records" do
        subject { @wrapped[0].create_payment(account).reload }
        let(:wrapped) { @wrapped[0] }

        it { should be_a AlleApi::Payment }
        it { should be_persisted }
        its(:source) { should eq wrapped.source.with_indifferent_access }
        its(:remote_id) { should eq wrapped.remote_id }
        its(:remote_auction_id) { should eq wrapped.remote_auction_id }
        its(:buyer_id) { should eq wrapped.buyer_id }
        its(:kind) { should eq wrapped.type }
        its(:status) { should eq wrapped.status }
        its(:amount) { should eq wrapped.amount }
        its(:postage_amount) { should eq wrapped.postage_amount }
        its(:created_at) { should eq wrapped.created_at }
        its(:received_at) { should eq wrapped.received_at }
        its(:price) { should eq wrapped.price }
        its(:count) { should eq wrapped.count }
        its(:details) { should eq wrapped.details }
        its(:completed) { should eq wrapped.completed }
        its(:parent_remote_id) { should eq wrapped.parent_remote_id }
      end
    end
  end

end

# encoding: utf-8
require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::GetPayments do

  # include_examples 'api action', :do_get_my_incoming_payments do
  #   let(:args) do
  #     { buyer_id: 12, auction_id: 13, limit: 5, offset: 20,
  #       date_from: Date.yesterday, date_to: Date.today }
  #   end
  #   let(:expected_body) do
  #     { session_handle: client.session_handle,
  #       buyer_id:             args[:buyer_id],
  #       item_id:              args[:auction_id],
  #       trans_recv_date_from: args[:date_from],
  #       trans_recv_date_to:   args[:date_to],
  #       trans_page_limit:     args[:limit],
  #       trans_offset:         args[:offset] }
  #   end
  #   let(:actual_body) { subject.request_body(args) }
  #
  #   describe "#validate!" do
  #     it "allows passing all filters" do
  #       expect {
  #         subject.validate!(expected_body)
  #       }.to_not raise_error
  #     end
  #
  #     optional = %w(
  #       buyer_id item_id trans_recv_date_from
  #       trans_recv_date_to trans_page_limit trans_offset
  #     ).map(&:to_sym)
  #     optional.map(&:to_sym).each do |key|
  #       it "allows passing nil to #{key}" do
  #         params = expected_body
  #         params.delete(key)
  #
  #         expect {
  #           subject.validate!(params)
  #         }.to_not raise_error
  #       end
  #     end
  #   end
  #
  #   it_should_behave_like 'simple #request_body'
  #
  #   describe "uses wrapper", vcr: 'do_get_my_incoming_payments' do
  #     include_context 'authenticated and updated api client'
  #     before { @wrapped = api.get_payments }
  #     subject { @wrapped[0] }
  #
  #     context "wraps" do
  #       subject { @wrapped[0] }
  #
  #       it 'exposes proper attributes' do
  #         expect(subject).to be_a AlleApi::Wrapper::Payment
  #         # expect(subject.source).to eq @wrapped[0]
  #         expect(subject.remote_id).to eq 243626480
  #         expect(subject.remote_auction_id).to eq 3266166575
  #         expect(subject.buyer_id).to eq 5697909
  #         expect(subject.type).to eq 'co'
  #         expect(subject.status).to eq 'Zakończona'
  #         expect(subject.amount).to eq 2.0
  #         expect(subject.postage_amount).to eq 1.0
  #         expect(subject.created_at).to eq Time.at(1369134559).to_datetime
  #         expect(subject.received_at).to eq Time.at(1369134760).to_datetime
  #         expect(subject.price).to eq 1.0
  #         expect(subject.count).to eq 1
  #         expect(subject.details).to be_nil
  #         expect(subject.completed).to be_true
  #         expect(subject.parent_remote_id).to be_nil
  #       end
  #     end
  #
  #     context "creating records" do
  #       subject { @wrapped[0].create_payment(account).reload }
  #       let(:wrapped) { @wrapped[0] }
  #
  #       it 'exposes proper attributes' do
  #         expect(subject).to be_a AlleApi::Payment
  #         expect(subject).to be_persisted
  #         expect(subject.source).to eq wrapped.source
  #         expect(subject.remote_id).to eq wrapped.remote_id
  #         expect(subject.remote_auction_id).to eq wrapped.remote_auction_id
  #         expect(subject.buyer_id).to eq wrapped.buyer_id
  #         expect(subject.kind).to eq wrapped.type
  #         expect(subject.status).to eq wrapped.status
  #         expect(subject.amount).to eq wrapped.amount
  #         expect(subject.postage_amount).to eq wrapped.postage_amount
  #         expect(subject.created_at).to eq wrapped.created_at
  #         expect(subject.received_at).to eq wrapped.received_at
  #         expect(subject.price).to eq wrapped.price
  #         expect(subject.count).to eq wrapped.count
  #         expect(subject.details).to eq wrapped.details
  #         expect(subject.completed).to eq wrapped.completed
  #         expect(subject.parent_remote_id).to eq wrapped.parent_remote_id
  #       end
  #     end
  #   end
  # end

end

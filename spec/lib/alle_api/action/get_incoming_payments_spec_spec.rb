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
  end

end

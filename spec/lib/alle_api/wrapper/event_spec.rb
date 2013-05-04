require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Wrapper::Event do
  include_examples 'wrapper'

  describe '.wrap_multiple' do
    def wrap!
      described_class.wrap_multiple(result)
    end

    context 'when returns nil results' do
      let(:result) { nil }

      it 'equals empty array' do
        expect(wrap!).to eq([])
      end
    end

    context 'when returns single result' do
      let(:result) { 'result' }

      it 'returns array with one wrapper' do
        described_class.expects(:wrap).with('result')

        wrap!
      end
    end

    # context 'when returns array of results'
      # this is covered by shared example
  end


  describe :Coercions do
    it 'coerces remote_id to integer' do
      subject.remote_id = '123'
      expect(subject.remote_id).to eq(123)
    end

    it 'coerces remote_seller_id to integer' do
      subject.remote_seller_id = '123'
      expect(subject.remote_seller_id).to eq(123)
    end

    it 'coerces remote_auction_id to integer' do
      subject.remote_auction_id = '123'
      expect(subject.remote_auction_id).to eq(123)
    end

    it 'coerces current_price to float' do
      subject.current_price = "9.9"
      expect(subject.current_price).to eq(9.9)
    end

    it 'coerces occured_at to datetime' do
      time_object = stub(to_s: "1361806487")
      expected_time = Time.at(time_object.to_s.to_i)

      subject.occured_at = time_object

      expect(subject.occured_at).to eq(expected_time)
    end

    it 'coerces kind to string' do
      subject.kind = :now
      expect(subject.kind).to eq("now")
    end
  end

  describe '#model_klass' do
    it 'is equal End if kind is "end"' do
      subject.kind = "end"

      expect(subject.model_klass).to eq(AlleApi::AuctionEvent::End)
    end

    it 'is equal BuyNow if kind is "now"' do
      subject.kind = "now"

      expect(subject.model_klass).to eq(AlleApi::AuctionEvent::BuyNow)
    end

    it 'is equal Start if kind is "start"' do
      subject.kind = "start"

      expect(subject.model_klass).to eq(AlleApi::AuctionEvent::Start)
    end

    it 'is equal Update if kind is "change"' do
      subject.kind = "change"

      expect(subject.model_klass).to eq(AlleApi::AuctionEvent::Update)
    end
  end

  describe '.create_auction_event' do
    let(:event_wrapper) do
      build :event_wrapper, kind: 'end',
                            remote_auction_id: auction.remote_id
    end
    let(:account)       { create :account }
    let(:auction) { create :auction }

    subject { event_wrapper.create_auction_event(account) }

    it { should be_a AlleApi::AuctionEvent::End }
    its(:remote_id)         { should eq(event_wrapper.remote_id) }
    its(:remote_auction_id) { should eq(event_wrapper.remote_auction_id) }
    its(:remote_seller_id)  { should eq(event_wrapper.remote_seller_id) }
    its(:current_price)     { should eq(event_wrapper.current_price) }
    its(:occured_at)        { should eq(event_wrapper.occured_at) }

    its(:account) { should eq(account) }
    its(:auction) { should eq(auction) }

    context 'when auction is missing' do
      let(:event_wrapper) do
        build :event_wrapper, kind: 'end', remote_auction_id: 777
      end
      let(:auction) { nil }

      its(:auction) { should be_nil }
    end

    it 'does not create same event twice' do
      expect {
        event_wrapper.create_auction_event(account)
        event_wrapper.create_auction_event(account)
      }.to change(AlleApi::AuctionEvent, :count).from(0).to(1)
    end
  end

end

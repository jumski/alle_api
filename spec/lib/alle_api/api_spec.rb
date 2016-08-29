require 'spec_helper'
require 'rspec/allegro'
require 'support/savon_macros'

describe AlleApi::Api do
  include SavonMacros
  include_context 'mocked api client'
  before do
    AlleApi.stubs(client: client, api: api)
  end
  subject { api }

  describe '.new' do
    it 'when called with hash, creates new client with provided options' do
      AlleApi::Client.expects(:new).with(key: :value).returns(client)

      api = AlleApi::Api.new(key: :value)

      expect(api.client).to eq client
    end

    it 'when called with client, uses given client' do
      api = AlleApi::Api.new client

      expect(api.client).to eq client
    end
  end

  describe '#finish_auction' do
    it 'passess id to finish auctions' do
      subject.expects(:finish_auctions).with([1]).returns(finished: [])

      subject.finish_auction(1)
    end

    context 'when properly finished' do
      it 'returns true' do
        subject.stubs(finish_auctions: { finished: [1] })

        expect(subject.finish_auction(1)).to be_true
      end
    end

    context 'when not finished' do
      it 'returns false' do
        subject.stubs(finish_auctions: { finished: [] })

        expect(subject.finish_auction(1)).to be_false
      end
    end
  end
end

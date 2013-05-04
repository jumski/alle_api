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
    it 'creates new client with provided options' do
      AlleApi::Client.expects(:new).with('opts').returns(client)

      AlleApi::Api.new('opts')
    end
  end

  describe '#client' do
    it 'returns AlleApi::Client instance' do
      api.client.should be_kind_of AlleApi::Client
    end
  end

  describe '#authenticate' do
    it 'uses Action::Authenticate to return session handle' do
      fake_action = mock
      AlleApi::Action::Authenticate.
        expects(:new).with(client).returns(fake_action)
      fake_action.expects(:do).returns('handle')

      expect(subject.authenticate).to eq('handle')
    end
  end

  context "method proxing to Action classes" do
    def self.it_proxies_to(method, klass)
      let(:return_value) { 'do_return_value' }

      it "instantiates an action with client and calls #do passing it arguments" do
        fake_action = mock
        klass.expects(:new).with(client).returns(fake_action)
        fake_action.expects(:do).with(*arguments)

        api.send(method, *arguments)
      end

      it "returns what #do returns" do
        klass.stubs(new: stub(do: 'do_return_value'))

        expect(api.send(method, *arguments)).to eq('do_return_value')
      end
    end

    describe '#create_auction' do
      let(:arguments) { ['argument'] }

      it_proxies_to :create_auction, AlleApi::Action::CreateAuction
    end

    describe '#get_categories' do
      let(:arguments) { [] }

      it_proxies_to :get_categories, AlleApi::Action::GetCategories
    end

    describe '#get_journal' do
      let(:arguments) { 123 }

      it_proxies_to :get_journal, AlleApi::Action::GetJournal
    end

    describe '#get_fields' do
      let(:arguments) { [] }

      it_proxies_to :get_fields, AlleApi::Action::GetFields
    end

    describe '#get_fields_for_category' do
      let(:arguments) { 123 }

      it_proxies_to :get_fields_for_category,
        AlleApi::Action::GetFieldsForCategory
    end

    describe '#get_versions' do
      let(:arguments) { [] }

      it_proxies_to :get_versions, AlleApi::Action::GetVersions
    end

    describe '#finish_auctions' do
      let(:arguments) { [ [1, 2, 3] ] }

      it_proxies_to :finish_auctions, AlleApi::Action::FinishAuctions
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

end

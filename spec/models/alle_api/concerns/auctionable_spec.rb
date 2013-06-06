
require 'spec_helper'

silence_warnings do
  ActiveRecord::Migration.verbose = false
end

class AlleApi::DummyAuctionable < ActiveRecord::Base
  include AlleApi::Auctionable
end

describe AlleApi::Auctionable, :slow do
  around do |example|
    ActiveRecord::Base.connection.instance_eval do
      create_table :alle_api_dummy_auctionables do |t|
      end
    end

    example.run

    ActiveRecord::Base.connection.instance_eval do
      drop_table :alle_api_dummy_auctionables
    end
  end

  subject { described_class }

  let(:klass) { AlleApi::DummyAuctionable }
  let(:instance) { klass.new }
  subject { instance }

  it { should have_many :auctions }
  it { should have_one :auction_template }

  it 'delegates #allegro_account to #auction_template' do
    subject.stubs(auction_template: stub(account: fake = stub))

    expect(subject.allegro_account).to eq fake
  end

  it '#title_for_auction raises error' do
    expect {
      instance.title_for_auction
    }.to raise_error(AlleApi::ProvideOwnImplementationError)
  end

  it '#category_id_for_auction raises error' do
    expect {
      instance.category_id_for_auction
    }.to raise_error(AlleApi::ProvideOwnImplementationError)
  end
end

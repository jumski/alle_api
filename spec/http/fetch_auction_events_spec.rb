# encoding: utf-8
require 'spec_helper'
require 'rspec/allegro'

describe 'Happy Paths: fetch events', :http, vcr: 'fetch_auction_events' do

  include_context 'real api client'

  before do
    account.utility = true
    account.save!
  end

  let(:redis) { Redis.current }

  it 'uses full stack to update, authenticate and fetch events' do
    # update version key
    AlleApi.versions.update(:version_key)

    # obtain session handle and save it into account
    AlleApi::Job::Authenticate.new.perform(account.id)

    AlleApi::Job::FetchAuctionEvents.new.perform(account.id)

    expect(AlleApi::AuctionEvent.count).to eq(17)

    types = AlleApi::AuctionEvent.pluck(:type).uniq
    expected_types = %w(AlleApi::AuctionEvent::Start
                        AlleApi::AuctionEvent::End
                        AlleApi::AuctionEvent::BuyNow)
    expect(types.sort).to eq(expected_types.sort)
  end
end

# encoding: utf-8
require 'spec_helper'
require 'rspec/allegro'

describe 'Happy Paths: create and finish auction', :http do

  include_context 'real api client'
  include_context 'real category'

  before do
    account.utility = true
    account.save!

    @auction = create(:auction, account: account)
    @auction.auctionable.stubs(category_id_for_auction: category.id)
    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = true
    end
  end

  after do
    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = false
    end
  end

  let(:redis)  { Redis.current }

  def finish_auction(remote_id)
    finished_id = nil
    10.times.find do |iteration|
      time = 3
      duration = 0.2

      print "[#{iteration}/10] Wait #{time} seconds for WebAPI to propagate new auction "
      (time/0.2).to_i.times { sleep duration; print '.' }
      puts

      results = api.finish_auctions([remote_id])
      finished_id = results[:finished].first
      break if finished_id > 0
    end
    finished_id
  end

  it 'uses full stack to update, authenticate, create and finish' do
    # update version key
    AlleApi.versions.update(:version_key)

    # obtain session handle and save it into account
    AlleApi::Job::Authenticate.new.perform(account.id)

    created_auction = api.create_auction(@auction.to_allegro_auction)
    remote_id = created_auction[:item_id].to_i
    expect(remote_id).to be > 0

    raise "Cannot finish auction :(" unless remote_id == finish_auction(remote_id)
  end
end

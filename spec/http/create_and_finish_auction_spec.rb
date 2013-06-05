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

  it 'uses full stack to update, authenticate, create and finish' do
    # update version key
    AlleApi.versions.update(:version_key)

    # obtain session handle and save it into account
    AlleApi::Job::Authenticate.new.perform(account.id)

    created_auction = api.create_auction(@auction.to_allegro_auction)
    remote_id = created_auction[:item_id].to_i

    # wait for allegro, without this latter finishing will be failed
    print "Give some time for WebAPI to propagate new auction "
    20.times { sleep(0.25); print '.' }
    puts

    finish_results = AlleApi::Action::FinishAuctions.new(api.client).do([remote_id])

    expect(finish_results[:finished]).to eq([remote_id])
  end
end

# encoding: utf-8
require 'spec_helper'
require 'rspec/allegro'

describe 'Happy Paths: create and finish auction', :http do

  include_context 'authenticated and updated api client'
  include_context 'real category'
  include_context 'allow http connections'

  before do
    @auction = create(:auction, account: account)
    @auction.auctionable.stubs(category_id_for_auction: category.id)
  end

  it 'uses full stack to update, authenticate, create and finish' do
    created_auction = api.create_auction(@auction.to_allegro_auction)
    remote_id = created_auction[:item_id].to_i
    expect(remote_id).to be > 0

    finished_auction_id = wait_for_allegro_to_finish_auction(remote_id)

    unless remote_id == finished_auction_id
      raise "Cannot finish auction :("
    end
  end

  def wait_for_allegro_to_finish_auction(remote_id)
    wait_with_retry(for: "WebAPI to propagate new auction", seconds: 2, times: 4) do
      results = api.finish_auctions([remote_id])

      results[:finished].first.tap do |id|
        raise unless id.to_i == remote_id.to_i
      end
    end
  end
end

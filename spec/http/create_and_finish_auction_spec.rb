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

    finished_auction_id = finish_auction(remote_id)

    expect(finished_auction_id).not_to be_blank
    expect(finished_auction_id).to eq remote_id

    journal_entry = fetch_journal_entry(remote_id)
  end

  private

  def fetch_journal_entry(remote_id)
    wait_with_retry(for: 'fetching journal with just ended auction', seconds: 1, times: 90) do
      journal = api.get_journal(0)
      journal.find { |j| j.remote_auction_id == remote_id } or raise
    end
  end

  def finish_auction(remote_id)
    wait_with_retry(for: 'ending just created auction', seconds: 1, times: 90) do
      results = api.finish_auctions([remote_id])

      results[:finished].first.tap do |id|
        raise unless id.to_i == remote_id.to_i
      end
    end
  end
end

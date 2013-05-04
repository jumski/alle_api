class ChangeAlleApiAuctionEventsLimitOnRemoteIds < ActiveRecord::Migration
  def up
    change_column :alle_api_auction_events, :remote_id, :integer, limit: 8
    change_column :alle_api_auction_events, :remote_auction_id, :integer, limit: 8
    change_column :alle_api_auction_events, :remote_seller_id, :integer, limit: 8
  end

  def down
    change_column :alle_api_auction_events, :remote_id, :integer, limit: 4
    change_column :alle_api_auction_events, :remote_auction_id, :integer, limit: 4
    change_column :alle_api_auction_events, :remote_seller_id, :integer, limit: 4
  end
end

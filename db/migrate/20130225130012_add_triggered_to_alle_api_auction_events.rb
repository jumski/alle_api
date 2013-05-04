class AddTriggeredToAlleApiAuctionEvents < ActiveRecord::Migration
  def change
    add_column :alle_api_auction_events, :triggered, :boolean, default: false
    add_index :alle_api_auction_events, :triggered
  end
end

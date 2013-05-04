class ChangeTriggeredToTriggeredAtOnAlleApiAuctionEvents < ActiveRecord::Migration
  def up
    add_column :alle_api_auction_events, :triggered_at, :datetime, default: nil
    remove_column :alle_api_auction_events, :triggered
  end

  def down
    add_column :alle_api_auction_events, :triggered, default: false
    remove_column :alle_api_auction_events, :triggered_at
  end
end

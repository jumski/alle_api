class AddAuctionIdToAlleApiDealEvents < ActiveRecord::Migration
  def change
    add_column :alle_api_deal_events, :auction_id, :integer
    add_index :alle_api_deal_events, :auction_id
  end
end

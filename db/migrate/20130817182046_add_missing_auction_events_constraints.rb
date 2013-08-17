class AddMissingAuctionEventsConstraints < ActiveRecord::Migration
  def up
    change_column :alle_api_auction_events, :type, :string, null: false
    change_column :alle_api_auction_events, :account_id, :string, null: false
  end

  def down
    change_column :alle_api_auction_events, :type, :string, null: true
    change_column :alle_api_auction_events, :account_id, :string, null: true
  end
end

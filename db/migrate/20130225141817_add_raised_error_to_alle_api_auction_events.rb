class AddRaisedErrorToAlleApiAuctionEvents < ActiveRecord::Migration
  def change
    add_column :alle_api_auction_events, :raised_error, :string
    add_index :alle_api_auction_events, :raised_error
  end
end

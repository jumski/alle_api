class AddDestinationStateToAlleApiAuctionEvents < ActiveRecord::Migration
  def change
    add_column :alle_api_auction_events, :destination_state, :string
    add_index :alle_api_auction_events, :destination_state
  end
end

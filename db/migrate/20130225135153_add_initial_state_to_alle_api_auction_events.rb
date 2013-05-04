class AddInitialStateToAlleApiAuctionEvents < ActiveRecord::Migration
  def change
    add_column :alle_api_auction_events, :initial_state, :string
    add_index :alle_api_auction_events, :initial_state
  end
end

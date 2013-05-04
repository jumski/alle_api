class RenameDestinationStateToAlteredStateOnAlleApiAuctionEvents < ActiveRecord::Migration
  def up
    rename_column :alle_api_auction_events, :destination_state, :altered_state
  end

  def down
    rename_column :alle_api_auction_events, :altered_state, :destination_state
  end
end

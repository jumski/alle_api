class RenameAuctionsToRemoteAuctions < ActiveRecord::Migration
  def up
    rename_table :alle_api_auctions, :alle_api_remote_auctions
  end

  def down
    rename_table :alle_api_remote_auctions, :alle_api_auctions
  end
end

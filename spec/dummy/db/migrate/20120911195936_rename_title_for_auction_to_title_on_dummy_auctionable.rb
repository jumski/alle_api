class RenameTitleForAuctionToTitleOnDummyAuctionable < ActiveRecord::Migration
  def up
    rename_column :dummy_auctionables, :title_for_auction, :title
  end

  def down
    rename_column :dummy_auctionables, :title, :title_for_auction
  end
end

class RemoveTitleForAuctionFromAlleApiDummyAuctionables < ActiveRecord::Migration
  def up
    remove_column :alle_api_dummy_auctionables, :title_for_auction
  end

  def down
    add_column :alle_api_dummy_auctionables, :title_for_auction, :string
  end
end

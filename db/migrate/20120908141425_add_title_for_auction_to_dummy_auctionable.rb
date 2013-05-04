class AddTitleForAuctionToDummyAuctionable < ActiveRecord::Migration
  def change
    add_column :alle_api_dummy_auctionables, :title_for_auction, :string
  end
end

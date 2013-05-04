class AddWeightToAlleApiDummyAuctionable < ActiveRecord::Migration
  def change
    add_column :alle_api_dummy_auctionables, :weight, :integer
  end
end

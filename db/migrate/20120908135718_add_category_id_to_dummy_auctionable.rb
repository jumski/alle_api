class AddCategoryIdToDummyAuctionable < ActiveRecord::Migration
  def change
    add_column :alle_api_dummy_auctionables, :category_id, :integer
    add_index :alle_api_dummy_auctionables, :category_id
  end
end

class CreateDummyAuctionables < ActiveRecord::Migration
  def change
    create_table :dummy_auctionables do |t|
      t.string :title_for_auction
      t.integer :weight
      t.integer :category_id

      t.timestamps
    end
  end
end

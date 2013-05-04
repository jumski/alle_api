class DropAlleApiDummyAuctionables < ActiveRecord::Migration
  def up
    drop_table :alle_api_dummy_auctionables
  end

  def down
    create_table :alle_api_dummy_auctionables do |t|
      t.string :name
      t.integer :category_id
      t.integer :weight
      t.timestamps
    end
  end
end

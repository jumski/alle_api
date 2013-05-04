class CreateAlleApiDummyAuctionables < ActiveRecord::Migration
  def change
    create_table :alle_api_dummy_auctionables do |t|
      t.string :name
      t.timestamps
    end
  end
end

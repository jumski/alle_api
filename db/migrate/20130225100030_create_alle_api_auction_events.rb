class CreateAlleApiAuctionEvents < ActiveRecord::Migration
  def change
    create_table :alle_api_auction_events do |t|
      t.integer :remote_id
      t.integer :remote_auction_id
      t.integer :auction_id
      t.integer :remote_seller_id
      t.decimal :current_price
      t.datetime :occured_at
      t.string :type

      t.timestamps
    end
    add_index :alle_api_auction_events, :remote_id
    add_index :alle_api_auction_events, :remote_auction_id
    add_index :alle_api_auction_events, :auction_id
    add_index :alle_api_auction_events, :remote_seller_id
    add_index :alle_api_auction_events, :type
  end
end

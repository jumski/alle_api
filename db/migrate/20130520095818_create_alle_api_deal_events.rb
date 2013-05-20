class CreateAlleApiDealEvents < ActiveRecord::Migration
  def up
    create_table :alle_api_deal_events do |t|
      t.integer :remote_id, null: false, limit: 8
      t.integer :remote_auction_id, null: false, limit: 8
      t.datetime :occured_at, null: false
      t.integer :remote_seller_id, null: false, limit: 8
      t.integer :remote_buyer_id, null: false, limit: 8
      t.integer :remote_deal_id, null: false, limit: 8
      t.integer :remote_transaction_id, null: false, limit: 8
      t.string :type, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
    add_index :alle_api_deal_events, :remote_id
    add_index :alle_api_deal_events, :remote_auction_id
    add_index :alle_api_deal_events, :remote_seller_id
    add_index :alle_api_deal_events, :remote_buyer_id
    add_index :alle_api_deal_events, :remote_deal_id
    add_index :alle_api_deal_events, :remote_transaction_id
    add_index :alle_api_deal_events, :type
  end

  def down
    remove_index :alle_api_deal_events, :remote_id
    remove_index :alle_api_deal_events, :remote_auction_id
    remove_index :alle_api_deal_events, :remote_seller_id
    remove_index :alle_api_deal_events, :remote_buyer_id
    remove_index :alle_api_deal_events, :remote_deal_id
    remove_index :alle_api_deal_events, :remote_transaction_id
    remove_index :alle_api_deal_events, :type

    drop_table :alle_api_deal_events
  end
end

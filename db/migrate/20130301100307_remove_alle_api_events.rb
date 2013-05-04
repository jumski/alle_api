class RemoveAlleApiEvents < ActiveRecord::Migration
  def up
    drop_table :alle_api_events
  end

  def down
    create_table "alle_api_auction_events", :force => true do |t|
      t.integer  "remote_id",         :limit => 8
      t.integer  "remote_auction_id", :limit => 8
      t.integer  "auction_id"
      t.integer  "remote_seller_id",  :limit => 8
      t.decimal  "current_price"
      t.datetime "occured_at"
      t.string   "type"
      t.datetime "created_at",                     :null => false
      t.datetime "updated_at",                     :null => false
      t.integer  "account_id"
      t.string   "initial_state"
      t.string   "altered_state"
      t.string   "raised_error"
      t.datetime "triggered_at"
    end
  end
end

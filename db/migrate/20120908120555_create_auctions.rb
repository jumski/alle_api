class CreateAuctions < ActiveRecord::Migration
  def up
    create_table "alle_api_auctions", :force => true do |t|
      t.float    "price"
      t.float    "economic_letter_price"
      t.float    "priority_letter_price"
      t.float    "economic_package_price"
      t.float    "priority_package_price"
      t.string   "additional_info"
      t.integer  "auctionable_id"
      t.string   "auctionable_type"
      t.datetime "created_at",                          :null => false
      t.datetime "updated_at",                          :null => false
      t.integer  "remote_id",              :limit => 8
      t.string   "title"
      t.string   "state"
      t.datetime "published_at"
      t.datetime "ended_at"
      t.datetime "bought_now_at"
      t.integer  "template_id"
    end

    add_index "alle_api_auctions", ["state"], :name => "index_alle_api_auctions_on_state"
    add_index "alle_api_auctions", ["template_id"], :name => "index_alle_api_auctions_on_auction_template_id"
  end

  def down
    drop_table :alle_api_auctions
  end
end


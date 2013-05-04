class CreateAuctionTemplates < ActiveRecord::Migration
  def up
    create_table "alle_api_auction_templates", :force => true do |t|
      t.float    "price"
      t.float    "economic_letter_price"
      t.float    "priority_letter_price"
      t.float    "economic_package_price"
      t.float    "priority_package_price"
      t.string   "title"
      t.string   "additional_info"
      t.integer  "auctionable_id"
      t.string   "auctionable_type"
      t.datetime "created_at",                               :null => false
      t.datetime "updated_at",                               :null => false
      t.boolean  "publishing_enabled",     :default => true
    end

  end

  def down
    drop_table :alle_api_auction_templates
  end
end

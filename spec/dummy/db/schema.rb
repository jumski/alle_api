# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130523114135) do

  create_table "alle_api_accounts", :force => true do |t|
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "login"
    t.string   "password"
    t.integer  "last_processed_event_id", :limit => 8,  :default => 0
    t.integer  "owner_id"
    t.string   "owner_type",              :limit => 30
    t.boolean  "utility"
  end

  add_index "alle_api_accounts", ["owner_id", "owner_type"], :name => "accounts_polymorphic_index"
  add_index "alle_api_accounts", ["owner_id"], :name => "index_alle_api_accounts_on_owner_id"
  add_index "alle_api_accounts", ["owner_type"], :name => "index_alle_api_accounts_on_owner_type"
  add_index "alle_api_accounts", ["utility"], :name => "index_alle_api_accounts_on_utility"

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

  add_index "alle_api_auction_events", ["account_id"], :name => "index_alle_api_auction_events_on_account_id"
  add_index "alle_api_auction_events", ["altered_state"], :name => "index_alle_api_auction_events_on_destination_state"
  add_index "alle_api_auction_events", ["auction_id"], :name => "index_alle_api_auction_events_on_auction_id"
  add_index "alle_api_auction_events", ["initial_state"], :name => "index_alle_api_auction_events_on_initial_state"
  add_index "alle_api_auction_events", ["raised_error"], :name => "index_alle_api_auction_events_on_raised_error"
  add_index "alle_api_auction_events", ["remote_auction_id"], :name => "index_alle_api_auction_events_on_remote_auction_id"
  add_index "alle_api_auction_events", ["remote_id"], :name => "index_alle_api_auction_events_on_remote_id"
  add_index "alle_api_auction_events", ["remote_seller_id"], :name => "index_alle_api_auction_events_on_remote_seller_id"
  add_index "alle_api_auction_events", ["type"], :name => "index_alle_api_auction_events_on_type"

  create_table "alle_api_auction_templates", :force => true do |t|
    t.float    "price"
    t.float    "economic_letter_price"
    t.float    "priority_letter_price"
    t.float    "economic_package_price"
    t.float    "priority_package_price"
    t.string   "title"
    t.string   "additional_info"
    t.integer  "auctionable_id"
    t.string   "auctionable_type",       :limit => 30
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.boolean  "publishing_enabled",                   :default => true
    t.integer  "account_id"
  end

  add_index "alle_api_auction_templates", ["account_id"], :name => "index_alle_api_auction_templates_on_account_id"
  add_index "alle_api_auction_templates", ["auctionable_id", "auctionable_type"], :name => "auction_templates_polymorphic_index"

  create_table "alle_api_auctions", :force => true do |t|
    t.float    "price"
    t.float    "economic_letter_price"
    t.float    "priority_letter_price"
    t.float    "economic_package_price"
    t.float    "priority_package_price"
    t.string   "additional_info"
    t.integer  "auctionable_id"
    t.string   "auctionable_type",          :limit => 30
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "remote_id",                 :limit => 8
    t.string   "title"
    t.string   "state"
    t.datetime "published_at"
    t.datetime "ended_at"
    t.datetime "bought_now_at"
    t.integer  "template_id"
    t.integer  "account_id"
    t.datetime "queued_for_finishing_at"
    t.datetime "queued_for_publication_at"
  end

  add_index "alle_api_auctions", ["account_id"], :name => "index_alle_api_auctions_on_account_id"
  add_index "alle_api_auctions", ["auctionable_id", "auctionable_type"], :name => "index_alle_api_auctions_on_auctionable_id_and_auctionable_type"
  add_index "alle_api_auctions", ["bought_now_at"], :name => "index_alle_api_auctions_on_bought_now_at"
  add_index "alle_api_auctions", ["created_at"], :name => "index_alle_api_auctions_on_created_at"
  add_index "alle_api_auctions", ["ended_at"], :name => "index_alle_api_auctions_on_ended_at"
  add_index "alle_api_auctions", ["published_at"], :name => "index_alle_api_auctions_on_published_at"
  add_index "alle_api_auctions", ["state"], :name => "index_alle_api_auctions_on_state"
  add_index "alle_api_auctions", ["template_id"], :name => "index_alle_api_auctions_on_auction_template_id"

  create_table "alle_api_categories", :force => true do |t|
    t.string   "name"
    t.string   "ancestry"
    t.integer  "allegro_parent_id"
    t.integer  "position"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "ancestry_depth",    :default => 0
    t.boolean  "leaf_node",         :default => true
    t.string   "path_text"
    t.datetime "soft_removed_at"
  end

  add_index "alle_api_categories", ["ancestry"], :name => "index_alle_api_categories_on_ancestry"

  create_table "alle_api_deal_events", :force => true do |t|
    t.integer  "remote_id",             :limit => 8, :null => false
    t.integer  "remote_auction_id",     :limit => 8, :null => false
    t.datetime "occured_at",                         :null => false
    t.integer  "remote_seller_id",      :limit => 8, :null => false
    t.integer  "remote_buyer_id",       :limit => 8, :null => false
    t.integer  "remote_deal_id",        :limit => 8, :null => false
    t.integer  "remote_transaction_id", :limit => 8, :null => false
    t.string   "type",                               :null => false
    t.integer  "quantity",                           :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "auction_id"
  end

  add_index "alle_api_deal_events", ["auction_id"], :name => "index_alle_api_deal_events_on_auction_id"
  add_index "alle_api_deal_events", ["remote_auction_id"], :name => "index_alle_api_deal_events_on_remote_auction_id"
  add_index "alle_api_deal_events", ["remote_buyer_id"], :name => "index_alle_api_deal_events_on_remote_buyer_id"
  add_index "alle_api_deal_events", ["remote_deal_id"], :name => "index_alle_api_deal_events_on_remote_deal_id"
  add_index "alle_api_deal_events", ["remote_id"], :name => "index_alle_api_deal_events_on_remote_id"
  add_index "alle_api_deal_events", ["remote_seller_id"], :name => "index_alle_api_deal_events_on_remote_seller_id"
  add_index "alle_api_deal_events", ["remote_transaction_id"], :name => "index_alle_api_deal_events_on_remote_transaction_id"
  add_index "alle_api_deal_events", ["type"], :name => "index_alle_api_deal_events_on_type"

  create_table "alle_api_fields", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.string   "form_type"
    t.string   "request_type"
    t.string   "default_value"
    t.string   "required"
    t.string   "position"
    t.string   "max_length"
    t.string   "min_value"
    t.string   "max_value"
    t.string   "options_descriptions"
    t.string   "options_values"
    t.string   "description"
    t.integer  "param_id"
    t.string   "param_values"
    t.integer  "parent_param_id"
    t.string   "parent_param_value"
    t.string   "unit"
    t.string   "options"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.datetime "soft_removed_at"
  end

  add_index "alle_api_fields", ["category_id"], :name => "index_alle_api_fields_on_category_id"
  add_index "alle_api_fields", ["param_id"], :name => "index_alle_api_fields_on_param_id"
  add_index "alle_api_fields", ["parent_param_id"], :name => "index_alle_api_fields_on_parent_param_id"

  create_table "alle_api_payments", :force => true do |t|
    t.integer  "remote_id"
    t.integer  "remote_auction_id"
    t.integer  "buyer_id"
    t.string   "kind"
    t.string   "status"
    t.float    "amount"
    t.float    "postage_amount"
    t.datetime "created_at",                        :null => false
    t.datetime "received_at"
    t.float    "price"
    t.integer  "count"
    t.string   "details"
    t.boolean  "completed"
    t.integer  "parent_remote_id"
    t.text     "source",            :limit => 2000
    t.datetime "updated_at",                        :null => false
  end

  create_table "alle_api_post_buy_forms", :force => true do |t|
    t.integer  "remote_id"
    t.integer  "buyer_id"
    t.string   "buyer_login"
    t.string   "buyer_email"
    t.float    "amount"
    t.float    "postage_amount"
    t.boolean  "invoice_requested"
    t.string   "message_to_seller"
    t.string   "payment_type"
    t.integer  "payment_id"
    t.string   "payment_status"
    t.datetime "payment_created_at"
    t.datetime "payment_received_at"
    t.datetime "payment_cancelled_at"
    t.float    "payment_amount"
    t.integer  "shipment_id"
    t.text     "source",               :limit => 2000
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "shipment_address",     :limit => 1000
    t.integer  "account_id"
  end

  add_index "alle_api_post_buy_forms", ["account_id"], :name => "index_alle_api_post_buy_forms_on_account_id"

  create_table "dummy_auctionables", :force => true do |t|
    t.string   "title"
    t.integer  "weight"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end

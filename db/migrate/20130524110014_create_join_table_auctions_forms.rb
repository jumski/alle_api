# This migration comes from alle_api (originally 20130524110014)
class CreateJoinTableAuctionsForms < ActiveRecord::Migration
  def up
    create_table :auctions_post_buy_forms do |t|
      t.integer :post_buy_form_id, null: false
      t.integer :auction_id, null: false
      t.integer :quantity, default: 1, null: false
      t.decimal :amount, null: false, precision: 30, scale: 10
      t.integer :title, null: false
      t.integer :country_id, null: false
      t.decimal :price, null: false, precision: 30, scale: 10
    end

    add_index :auctions_post_buy_forms, [:auction_id, :post_buy_form_id]
  end

  def down
    remove_index :auctions_post_buy_forms, [:auction_id, :post_buy_form_id]
    drop_table :auctions_post_buy_forms
  end
end

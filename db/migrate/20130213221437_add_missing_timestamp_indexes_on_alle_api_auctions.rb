class AddMissingTimestampIndexesOnAlleApiAuctions < ActiveRecord::Migration
  def up
    add_index :alle_api_auctions, :created_at
    add_index :alle_api_auctions, :ended_at
    add_index :alle_api_auctions, :published_at
    add_index :alle_api_auctions, :bought_now_at
  end

  def down
    remove_index :alle_api_auctions, :created_at
    remove_index :alle_api_auctions, :ended_at
    remove_index :alle_api_auctions, :published_at
    remove_index :alle_api_auctions, :bought_now_at
  end
end

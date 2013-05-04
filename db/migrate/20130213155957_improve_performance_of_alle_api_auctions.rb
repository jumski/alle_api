class ImprovePerformanceOfAlleApiAuctions < ActiveRecord::Migration
  def up
    change_column :alle_api_auctions, :auctionable_type, :string, limit: 30
    add_index :alle_api_auctions, [:auctionable_id, :auctionable_type]
  end

  def down
    remove_index :alle_api_auctions, [:auctionable_id, :auctionable_type]
    change_column :alle_api_auctions, :auctionable_type, :string, limit: 255
  end
end

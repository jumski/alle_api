class AddAccountIdToAlleApiAuctions < ActiveRecord::Migration
  def change
    add_column :alle_api_auctions, :account_id, :integer
    add_index :alle_api_auctions, :account_id
  end
end

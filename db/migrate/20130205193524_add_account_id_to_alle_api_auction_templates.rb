class AddAccountIdToAlleApiAuctionTemplates < ActiveRecord::Migration
  def change
    add_column :alle_api_auction_templates, :account_id, :integer
    add_index :alle_api_auction_templates, :account_id
  end
end

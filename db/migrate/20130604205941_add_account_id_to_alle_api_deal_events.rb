class AddAccountIdToAlleApiDealEvents < ActiveRecord::Migration
  def change
    add_column :alle_api_deal_events, :account_id, :integer, null: false
    add_index :alle_api_deal_events, :account_id
  end
end

class AddRemoteIdToAlleApiAccounts < ActiveRecord::Migration
  def change
    add_column :alle_api_accounts, :remote_id, :integer, null: false, default: 0, limit: 8
    add_index :alle_api_accounts, :remote_id
  end
end

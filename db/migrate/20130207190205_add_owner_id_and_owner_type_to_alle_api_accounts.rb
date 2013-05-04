class AddOwnerIdAndOwnerTypeToAlleApiAccounts < ActiveRecord::Migration
  def change
    add_column :alle_api_accounts, :owner_id, :integer
    add_index :alle_api_accounts, :owner_id
    add_column :alle_api_accounts, :owner_type, :string
    add_index :alle_api_accounts, :owner_type
  end
end

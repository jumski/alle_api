class AddUtilityToAlleApiAccounts < ActiveRecord::Migration
  def change
    add_column :alle_api_accounts, :utility, :boolean
    add_index :alle_api_accounts, :utility
  end
end

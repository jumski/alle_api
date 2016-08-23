class AddActiveToAlleApiAccounts < ActiveRecord::Migration
  def up
    add_column :alle_api_accounts, :active, :boolean, default: true
  end

  def down
    remove_column :alle_api_accounts, :active
  end
end

class AddLoginAndPasswordToAlleApiAccounts < ActiveRecord::Migration
  def change
    add_column :alle_api_accounts, :login, :string
    add_column :alle_api_accounts, :password, :string
  end
end

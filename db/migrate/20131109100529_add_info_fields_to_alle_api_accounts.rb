class AddInfoFieldsToAlleApiAccounts < ActiveRecord::Migration
  def change
    add_column :alle_api_accounts, :phone_number, :string
    add_column :alle_api_accounts, :email, :string
    add_column :alle_api_accounts, :bank_account_number, :string
  end
end

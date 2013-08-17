class AddMissingAccountsConstraints < ActiveRecord::Migration
  def up
    add_index :alle_api_accounts, :login, unique: true
    change_column :alle_api_accounts, :login,      :string,  null: false
    change_column :alle_api_accounts, :password,   :string,  null: false
    change_column :alle_api_accounts, :owner_id,   :integer, null: false
    change_column :alle_api_accounts, :owner_type, :string,  null: false
    change_column :alle_api_accounts, :utility,    :boolean, null: false
  end

  def down
    remove_index :alle_api_accounts, :login
    change_column :alle_api_accounts, :login,      :string,  null: true
    change_column :alle_api_accounts, :password,   :string,  null: true
    change_column :alle_api_accounts, :owner_id,   :integer, null: true
    change_column :alle_api_accounts, :owner_type, :string,  null: true
    change_column :alle_api_accounts, :utility,    :boolean, null: true
  end
end

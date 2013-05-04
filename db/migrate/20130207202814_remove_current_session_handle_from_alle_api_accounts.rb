class RemoveCurrentSessionHandleFromAlleApiAccounts < ActiveRecord::Migration
  def up
    remove_column :alle_api_accounts, :current_session_handle
  end

  def down
    add_column :alle_api_accounts, :current_session_handle, :string
  end
end

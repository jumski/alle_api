class AddCurrentSessionHandleToAlleApiAccounts < ActiveRecord::Migration
  def change
    add_column :alle_api_accounts, :current_session_handle, :string
  end
end

class AddLastProcessedEventIdToAlleApiAccounts < ActiveRecord::Migration
  def change
    add_column :alle_api_accounts, :last_processed_event_id, :integer, default: 0
  end
end

class IncreaseLimitOnAlleApiAccountsLastProcessedEventId < ActiveRecord::Migration
  def up
    change_column :alle_api_accounts, :last_processed_event_id, :integer, limit: 8
  end

  def down
    change_column :alle_api_accounts, :last_processed_event_id, :integer, limit: 4
  end
end

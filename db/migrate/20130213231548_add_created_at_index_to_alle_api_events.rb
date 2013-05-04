class AddCreatedAtIndexToAlleApiEvents < ActiveRecord::Migration
  def up
    add_index :alle_api_events, :created_at
  end

  def down
    remove_index :alle_api_events, :created_at
  end
end

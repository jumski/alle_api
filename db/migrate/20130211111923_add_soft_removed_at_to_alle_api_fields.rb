class AddSoftRemovedAtToAlleApiFields < ActiveRecord::Migration
  def change
    add_column :alle_api_fields, :soft_removed_at, :datetime, default: nil
  end
end

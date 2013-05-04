class AddSoftRemovedAtToAlleApiCategories < ActiveRecord::Migration
  def change
    add_column :alle_api_categories, :soft_removed_at, :datetime
  end
end

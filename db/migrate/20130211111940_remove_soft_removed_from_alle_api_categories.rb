class RemoveSoftRemovedFromAlleApiCategories < ActiveRecord::Migration
  def up
    remove_column :alle_api_categories, :soft_removed
  end

  def down
    add_column :alle_api_categories, :soft_removed, :datetime
  end
end

class AddSoftRemovedToAlleApiCategories < ActiveRecord::Migration
  def change
    add_column :alle_api_categories, :soft_removed, :boolean, default: false
    add_index :alle_api_categories, :soft_removed
  end
end

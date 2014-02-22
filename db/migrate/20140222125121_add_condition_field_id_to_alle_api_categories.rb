class AddConditionFieldIdToAlleApiCategories < ActiveRecord::Migration
  def change
    add_column :alle_api_categories, :condition_field_id, :integer
    add_index :alle_api_categories, :condition_field_id
  end
end

class RemoveHasConditionFieldFromAlleApiCategories < ActiveRecord::Migration
  def up
    remove_column :alle_api_categories, :has_condition_field
  end

  def down
    add_column :alle_api_categories, :has_condition_field, :boolean, null: false, default: false
  end
end

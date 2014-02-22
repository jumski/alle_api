class AddHasConditionFieldToAlleApiCategories < ActiveRecord::Migration
  def change
    add_column :alle_api_categories, :has_condition_field, :boolean, null: false, default: false
  end
end

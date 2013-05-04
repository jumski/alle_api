class RemoveConditionFidFromAlleApiCategories < ActiveRecord::Migration
  def up
    remove_column :alle_api_categories, :condition_fid
  end

  def down
    add_column :alle_api_categories, :condition_fid, :integer
  end
end

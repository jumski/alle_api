class RenameAlleApiCategoriesParentIdToAllegroParentId < ActiveRecord::Migration
  def up
    rename_column :alle_api_categories, :parent_id, :allegro_parent_id
  end

  def down
    rename_column :alle_api_categories, :allegro_parent_id, :parent_id
  end
end

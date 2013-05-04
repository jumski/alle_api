class CreateCategories < ActiveRecord::Migration
  def up
    create_table :alle_api_categories do |t|
      t.string   :name
      t.string   :ancestry
      t.integer  :parent_id
      t.integer  :position
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
      t.integer  :ancestry_depth, :default => 0
      t.boolean  :leaf_node,      :default => true
      t.integer  :condition_fid
      t.string   :path_text
    end

    add_index :alle_api_categories, [:ancestry], :name => :index_alle_api_categories_on_ancestry
  end

  def down
    drop_table :alle_api_categories
  end
end

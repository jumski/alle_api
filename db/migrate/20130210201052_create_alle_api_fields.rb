class CreateAlleApiFields < ActiveRecord::Migration
  def change
    create_table :alle_api_fields do |t|
      t.string :name
      t.integer :category_id
      t.string :form_type
      t.string :request_type
      t.string :default_value
      t.string :required
      t.string :position
      t.string :max_length
      t.string :min_value
      t.string :max_value
      t.string :options_descriptions
      t.string :options_values
      t.string :description
      t.integer :param_id
      t.string :param_values
      t.integer :parent_param_id
      t.string :parent_param_value
      t.string :unit
      t.string :options

      t.timestamps
    end
    add_index :alle_api_fields, :category_id
    add_index :alle_api_fields, :param_id
    add_index :alle_api_fields, :parent_param_id
  end
end

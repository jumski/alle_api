class CreateAlleApiEvents < ActiveRecord::Migration
  def up
    create_table "alle_api_events", :force => true do |t|
      t.string   "kind"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
      t.integer  "originator_id"
      t.text     "values"
      t.string   "originator_type"
    end

    add_index "alle_api_events", ["kind"], :name => "index_alle_api_events_on_type"
    add_index "alle_api_events", ["originator_type"], :name => "index_alle_api_events_on_originator_type"
  end

  def down
    drop_table :alle_api_events
  end
end


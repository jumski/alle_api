class ImprovePerformanceOfPolymorphicModels < ActiveRecord::Migration
  def up
    # templates
    change_column :alle_api_auction_templates, :auctionable_type, :string, limit: 30
    add_index :alle_api_auction_templates, [:auctionable_id, :auctionable_type], name: 'auction_templates_polymorphic_index'

    # accounts
    change_column :alle_api_accounts, :owner_type, :string, limit: 30
    add_index :alle_api_accounts, [:owner_id, :owner_type], name: 'accounts_polymorphic_index'

    # events
    change_column :alle_api_events, :originator_type, :string, limit: 30
    add_index :alle_api_events, [:originator_id, :originator_type], name: 'events_polymorphic_index'
  end

  def down
    remove_index :alle_api_auction_templates, name: 'auction_templates_polymorphic_index'
    change_column :alle_api_auction_templates, :auctionable_type, :string, limit: 255

    remove_index :alle_api_accounts, name: 'accounts_polymorphic_index'
    change_column :alle_api_accounts, :owner_type, :string, limit: 255

    remove_index :alle_api_events, name: 'events_polymorphic_index'
    change_column :alle_api_events, :originator_type, :string, limit: 255
  end
end

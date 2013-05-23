class AddAccountIdToAlleApiPostBuyForms < ActiveRecord::Migration
  def change
    add_column :alle_api_post_buy_forms, :account_id, :integer
    add_index :alle_api_post_buy_forms, :account_id
  end
end

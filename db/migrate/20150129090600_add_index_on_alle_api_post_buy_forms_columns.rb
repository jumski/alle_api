class AddIndexOnAlleApiPostBuyFormsColumns < ActiveRecord::Migration
  def up
    add_index :alle_api_post_buy_forms, :remote_id
    add_index :alle_api_post_buy_forms, :buyer_id
    add_index :alle_api_post_buy_forms, :payment_id
    add_index :alle_api_post_buy_forms, :payment_type
    add_index :alle_api_post_buy_forms, :payment_status
    add_index :alle_api_post_buy_forms, :shipment_id
  end

  def down
    remove_index :alle_api_post_buy_forms, :remote_id
    remove_index :alle_api_post_buy_forms, :buyer_id
    remove_index :alle_api_post_buy_forms, :payment_id
    remove_index :alle_api_post_buy_forms, :payment_type
    remove_index :alle_api_post_buy_forms, :payment_status
    remove_index :alle_api_post_buy_forms, :shipment_id
  end
end

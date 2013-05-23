class AddShipmentAddressToAlleApiPostBuyForms < ActiveRecord::Migration
  def change
    add_column :alle_api_post_buy_forms, :shipment_address, :string, limit: 1000
  end
end

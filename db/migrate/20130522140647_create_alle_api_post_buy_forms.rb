class CreateAlleApiPostBuyForms < ActiveRecord::Migration
  def change
    create_table :alle_api_post_buy_forms do |t|
      t.integer :remote_id
      t.integer :buyer_id
      t.string :buyer_login
      t.string :buyer_email
      t.float :amount
      t.float :postage_amount
      t.boolean :invoice_requested
      t.string :message_to_seller
      t.string :payment_type
      t.integer :payment_id
      t.string :payment_status
      t.datetime :payment_created_at
      t.datetime :payment_received_at
      t.datetime :payment_cancelled_at
      t.float :payment_amount
      t.integer :shipment_id
      t.string :source

      t.timestamps
    end
  end
end

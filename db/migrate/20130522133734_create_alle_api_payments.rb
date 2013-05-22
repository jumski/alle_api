class CreateAlleApiPayments < ActiveRecord::Migration
  def change
    create_table :alle_api_payments do |t|
      t.integer :remote_id
      t.integer :remote_auction_id
      t.integer :buyer_id
      t.string :kind
      t.string :status
      t.float :amount
      t.float :postage_amount
      t.datetime :created_at
      t.datetime :received_at
      t.float :price
      t.integer :count
      t.string :details
      t.boolean :completed
      t.integer :parent_remote_id
      t.string :source

      t.timestamps
    end
  end
end

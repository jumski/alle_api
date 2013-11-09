class AddProperLimitsToAlleApiPayementsIds < ActiveRecord::Migration
  def up
    change_column :alle_api_payments, :remote_id, :integer, limit: 8
    change_column :alle_api_payments, :remote_auction_id, :integer, limit: 8
    change_column :alle_api_payments, :buyer_id, :integer, limit: 8
    change_column :alle_api_payments, :parent_remote_id, :integer, limit: 8
  end

  def down
    change_column :alle_api_payments, :remote_id, :integer, limit: 4
    change_column :alle_api_payments, :remote_auction_id, :integer, limit: 4
    change_column :alle_api_payments, :buyer_id, :integer, limit: 4
    change_column :alle_api_payments, :parent_remote_id, :integer, limit: 4
  end
end

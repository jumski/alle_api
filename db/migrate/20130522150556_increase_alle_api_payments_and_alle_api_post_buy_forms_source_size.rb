class IncreaseAlleApiPaymentsAndAlleApiPostBuyFormsSourceSize < ActiveRecord::Migration
  def up
    change_column :alle_api_payments, :source, :string, limit: 2000
    change_column :alle_api_post_buy_forms, :source, :string, limit: 2000
  end

  def down
    change_column :alle_api_payments, :source, :string, limit: 255
    change_column :alle_api_post_buy_forms, :source, :string, limit: 255
  end
end

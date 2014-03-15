class ConvertFloatsToBigdecimals < ActiveRecord::Migration
  def up
    { precision: 19, scale: 4 , default: 0.0, null: false }.tap do |opts|
      change_column :alle_api_auction_templates, :price, :decimal, opts
      change_column :alle_api_auction_templates, :economic_letter_price, :decimal, opts
      change_column :alle_api_auction_templates, :priority_letter_price, :decimal, opts
      change_column :alle_api_auction_templates, :economic_package_price, :decimal, opts
      change_column :alle_api_auction_templates, :priority_package_price, :decimal, opts
      change_column :alle_api_auctions, :price, :decimal, opts
      change_column :alle_api_auctions, :economic_letter_price, :decimal, opts
      change_column :alle_api_auctions, :priority_letter_price, :decimal, opts
      change_column :alle_api_auctions, :economic_package_price, :decimal, opts
      change_column :alle_api_auctions, :priority_package_price, :decimal, opts
    end

    { precision: 19, scale: 4 }.tap do |opts|
      change_column :alle_api_payments, :amount, :decimal, opts
      change_column :alle_api_payments, :postage_amount, :decimal, opts
      change_column :alle_api_payments, :price, :decimal, opts

      change_column :alle_api_post_buy_forms, :amount, :decimal, opts
      change_column :alle_api_post_buy_forms, :postage_amount, :decimal, opts
      change_column :alle_api_post_buy_forms, :payment_amount, :decimal, opts
    end
  end

  def down
    change_column :alle_api_auction_templates, :price, :float
    change_column :alle_api_auction_templates, :economic_letter_price, :float
    change_column :alle_api_auction_templates, :priority_letter_price, :float
    change_column :alle_api_auction_templates, :economic_package_price, :float
    change_column :alle_api_auction_templates, :priority_package_price, :float

    change_column :alle_api_auctions, :price, :float
    change_column :alle_api_auctions, :economic_letter_price, :float
    change_column :alle_api_auctions, :priority_letter_price, :float
    change_column :alle_api_auctions, :economic_package_price, :float
    change_column :alle_api_auctions, :priority_package_price, :float
    change_column :alle_api_payments, :amount, :float
    change_column :alle_api_payments, :postage_amount, :float
    change_column :alle_api_payments, :price, :float

    change_column :alle_api_post_buy_forms, :amount, :float
    change_column :alle_api_post_buy_forms, :postage_amount, :float
    change_column :alle_api_post_buy_forms, :payment_amount, :float
  end
end

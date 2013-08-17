class AddMisssingAuctionsAndAuctionTemplatesConstraints < ActiveRecord::Migration
  def up
    %w(price
       economic_package_price
       priority_package_price
       economic_letter_price
       priority_letter_price).each do |column|

      change_both column, :float, null: false, default: 0
    end

    change_both :account_id,     :integer, null: false
    change_both :auctionable_id, :integer, null: false

    change_both :title,            :string, null: false
    change_both :additional_info,  :string, limit: 2000
    change_both :auctionable_type, :string, null: false

    change_column :alle_api_auctions, :state, :string, null: false
    change_column :alle_api_auction_templates, :publishing_enabled, :boolean, null: false
  end

  def down
    %w(price
       economic_package_price
       priority_package_price
       economic_letter_price
       priority_letter_price).each do |column|

      change_both column, :float, null: true, default: nil
    end

    change_both :account_id,     :integer, null: true
    change_both :auctionable_id, :integer, null: true

    change_both :title,            :string, null: true
    change_both :additional_info,  :string, limit: nil
    change_both :auctionable_type, :string, null: true

    change_column :alle_api_auctions, :state, :string, null: true
    change_column :alle_api_auction_templates, :publishing_enabled, :boolean, null: true
  end

  private
    def change_both(*args)
      change_column :alle_api_auctions,          *args
      change_column :alle_api_auction_templates, *args
    end

end

class IncreaseLimitOnAlleApiAuctionTemplatesAdditionalInfo < ActiveRecord::Migration
  def up
    change_column :alle_api_auction_templates, :additional_info, :string, limit: 2000
    change_column :alle_api_auctions, :additional_info, :string, limit: 2000
  end

  def down
    change_column :alle_api_auction_templates, :additional_info, :string, limit: 255
    change_column :alle_api_auctions, :additional_info, :string, limit: 255
  end
end

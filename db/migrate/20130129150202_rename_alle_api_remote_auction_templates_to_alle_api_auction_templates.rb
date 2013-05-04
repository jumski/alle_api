class RenameAlleApiRemoteAuctionTemplatesToAlleApiAuctionTemplates < ActiveRecord::Migration
  def up
    rename_table :alle_api_remote_auction_templates, :alle_api_auction_templates
  end

  def down
    rename_table :alle_api_auction_templates, :alle_api_remote_auction_templates
  end
end

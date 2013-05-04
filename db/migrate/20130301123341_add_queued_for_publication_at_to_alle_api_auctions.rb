class AddQueuedForPublicationAtToAlleApiAuctions < ActiveRecord::Migration
  def change
    add_column :alle_api_auctions, :queued_for_publication_at, :datetime
  end
end

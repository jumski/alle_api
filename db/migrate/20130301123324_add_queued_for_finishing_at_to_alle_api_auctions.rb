class AddQueuedForFinishingAtToAlleApiAuctions < ActiveRecord::Migration
  def change
    add_column :alle_api_auctions, :queued_for_finishing_at, :datetime
  end
end

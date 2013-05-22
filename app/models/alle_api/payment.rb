module AlleApi
  class Payment < ActiveRecord::Base
    attr_accessible :amount, :buyer_id, :completed, :count, :created_at, :details, :kind, :parent_remote_id, :postage_amount, :price, :received_at, :remote_auction_id, :remote_id, :source, :status

    serialize :source
  end
end

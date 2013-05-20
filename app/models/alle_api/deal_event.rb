module AlleApi
  class DealEvent < ActiveRecord::Base
    attr_accessible :occured_at, :quantity, :remote_auction_id, :remote_buyer_id, :remote_deal_id, :remote_id, :remote_seller_id, :remote_transaction_id, :type, :auction

    belongs_to :auction

    class NewDeal           < self; end
    class NewTransaction    < self; end
    class CancelTransaction < self; end
    class FinishTransaction < self; end
  end
end

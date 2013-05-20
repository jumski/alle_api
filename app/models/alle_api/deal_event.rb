module AlleApi
  class DealEvent < ActiveRecord::Base
    NUMERICAL = %w(
      remote_auction_id remote_buyer_id
      remote_deal_id remote_id remote_seller_id
      remote_transaction_id
    ).map(&:to_sym)

    ACCESSIBLE = [:occured_at, :quantity, :auction] + NUMERICAL

    attr_accessible *ACCESSIBLE

    validates *ACCESSIBLE, presence: true
    validates *NUMERICAL, numericality: true

    belongs_to :auction

    class NewDeal           < self; end
    class NewTransaction    < self; end
    class CancelTransaction < self; end
    class FinishTransaction < self; end
  end
end

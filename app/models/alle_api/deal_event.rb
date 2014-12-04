module AlleApi
  class DealEvent < ActiveRecord::Base
    NUMERICAL = %w(
      remote_auction_id remote_buyer_id
      remote_deal_id remote_id remote_seller_id
      remote_transaction_id
    ).map(&:to_sym)

    ACCESSIBLE = [:occured_at, :quantity, :auction] + NUMERICAL
    REQUIRED = ACCESSIBLE - [:auction]

    attr_accessible *ACCESSIBLE

    validates *REQUIRED, presence: true
    validates *NUMERICAL, numericality: true

    belongs_to :auction
    belongs_to :account
    belongs_to :post_buy_form, primary_key: :remote_id, foreign_key: :remote_transaction_id

    before_create :steal_account_from_auction

    class << self
      def new_transactions
        where(type: 'AlleApi::DealEvent::NewTransaction')
      end

      def lacking_post_buy_form
        new_transactions.
          joins("LEFT OUTER JOIN alle_api_post_buy_forms pbf ON remote_transaction_id = pbf.remote_id").
          where("pbf.remote_id IS NULL")
      end

      def missing_transaction_ids
        new_transactions.lacking_post_buy_form.pluck(:remote_transaction_id)
      end
    end

    def inspect
      klass = self.class.name.split('::').last.underscore
      "<DealEvent : #{id} : #{klass} : #{remote_transaction_id}>"
    end

    class NewDeal           < self; end # user bought something
    class NewTransaction    < self; end # user initiated payment
    class CancelTransaction < self; end # user cancelled payment
    class FinishTransaction < self; end # user's payment is confirmed

    private
      def steal_account_from_auction
        self.account = auction.account
      end

  end
end

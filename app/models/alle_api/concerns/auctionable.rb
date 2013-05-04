
module AlleApi
  module Auctionable
    extend ActiveSupport::Concern

    included do
      has_many :auctions,
        as: :auctionable,
        class_name: 'AlleApi::Auction'

      has_one :auction_template,
        as: :auctionable,
        class_name: 'AlleApi::AuctionTemplate'

      has_one :allegro_account,
        class_name: "AlleApi::Account",
        through: :auction_template,
        source: :account
    end

    def title_for_auction
      raise_not_implemented_error 'title_for_auction'
    end

    def category_id_for_auction
      raise_not_implemented_error 'category_id_for_auction'
    end

    private
      def raise_not_implemented_error(method_name)
        raise ProvideOwnImplementationError.new(method_name, self.class)
      end
  end
end


module AlleApi
  module AccountOwner
    extend ActiveSupport::Concern

    included do
      has_many :allegro_accounts,
        class_name: 'AlleApi::Account',
        as: :owner

      has_many :auctions,
        class_name: 'AlleApi::Auction',
        through: :allegro_accounts

      has_many :auction_templates,
        class_name: 'AlleApi::AuctionTemplate',
        through: :allegro_accounts,
        source: :templates
    end
  end
end

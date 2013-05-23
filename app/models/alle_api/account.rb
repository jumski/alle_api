class AlleApi::Account < ActiveRecord::Base
  attr_accessible :login, :password

  has_many :auctions
  has_many :auction_events
  has_many :triggered_events,
    class_name: 'AlleApi::AuctionEvent',
    conditions: "triggered_at IS NOT NULL"
  has_many :untriggered_events,
    class_name: 'AlleApi::AuctionEvent',
    conditions: "triggered_at IS NULL"
  has_many :deal_events
  has_many :templates, class_name: 'AlleApi::AuctionTemplate'
  has_many :post_buy_forms
  belongs_to :owner, polymorphic: true

  validates :login, :password, presence: true
  validates :login, uniqueness: true
  validates :password, length: { in: 6..16 }
  validates :last_processed_event_id, numericality: true

  class << self
    def utility
      where(utility: true).first
    end
  end

  def api
    AlleApi::Api.new(credentials)
  end

  def client
    api.client
  end

  def credentials
    { login: login,
      password: password,
      webapi_key: AlleApi.config.webapi_key,
      version_key: AlleApi.versions[:version_key] }
  end

  def last_auction_event_remote_id
    return last_processed_event_id unless auction_events.any?

    auction_events.maximum(:remote_id)
  end
end

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

  validates :login, :password, :remote_id, presence: true
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

  def last_deal_event_remote_id
    deal_events.maximum(:remote_id) || 0
  end

  def missing_transaction_ids
    deal_events.missing_transaction_ids
  end

  def about_me_url
    if AlleApi.config.sandbox
      "http://allegro.pl.webapisandbox.pl/show_user.php?uid=#{remote_id}"
    else
      "http://allegro.pl/my_page.php?uid=#{remote_id}"
    end
  end
end

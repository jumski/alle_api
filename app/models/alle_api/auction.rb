
class AlleApi::Auction < ActiveRecord::Base
  include AlleApi::AuctionStateMachine
  include AlleApi::AuctionSharedBehaviour

  after_destroy :finish_remote!

  # primary associations
  belongs_to :template, class_name: '::AlleApi::AuctionTemplate'
  has_many :all_auctions,
    class_name: '::AlleApi::Auction',
    through: :template,
    source: :auctions
  has_many :deal_events, class_name: '::AlleApi::DealEvent'
  has_and_belongs_to_many :post_buy_forms,
    class_name: '::AlleApi::PostBuyForm'

  attr_accessible *AlleApi::AuctionTemplate::SHARED_ATTRIBUTES,
    :remote_id, :published_at, :bought_now_at, :ended_at, :state

  validates :title, presence: true

  delegate :current_auction, :disable_publishing!, :enable_publishing!,
           :finish_current_auction!, :end_publishing!,
    to: :template

  after_create :increment_counter_on_auctionable
  def increment_counter_on_auctionable
    if auctionable.respond_to? :auctions_count
      auctionable.class.increment_counter(:auctions_count, auctionable_id)
    end
  end

  after_destroy :decrement_counter_on_auctionable
  def decrement_counter_on_auctionable
    if auctionable.respond_to? :auctions_count
      auctionable.class.decrement_counter(:auctions_count, auctionable_id)
    end
  end

  class << self
    ########### SCOPES #################
    def published()              where(state: 'published')              end
    def queued_for_publication() where(state: 'queued_for_publication') end
    def bought_now()             where(state: 'bought_now')             end
    def ended()                  where(state: 'ended')                  end

    def recently(state)
      where(state: state).
        where("#{table_name}.#{state}_at > ?", 7.days.ago).
        order("#{table_name}.#{state}_at DESC")
    end

    def ending_soon
      published.
        where("#{table_name}.published_at > ?", 30.days.ago).
        where("#{table_name}.published_at < ?", 27.days.ago).
        order("#{table_name}.published_at ASC")
    end

    ########## CLASS METHODS ###########
    def shipment_prices
      YAML.load_file(Rails.root.join('config/shipment_prices.yml')).with_indifferent_access
    end

    def shipment_price_by_weight(type, weight)
      weight = weight.to_i
      prices = self.shipment_prices[type]
      ranges = prices.keys.sort

      range = ranges.find { |range| range >= weight }
      range = ranges.max unless range

      prices[range].to_f
    end

    def build_for_auctionable(auctionable)
      auction = new({
        title: auctionable.title_for_auction,
        economic_package_price:
          shipment_price_by_weight(:economic_package_price, auctionable.weight),
        priority_package_price:
          shipment_price_by_weight(:priority_package_price, auctionable.weight),
        economic_letter_price:
          shipment_price_by_weight(:economic_letter_price, auctionable.weight),
        priority_letter_price:
          shipment_price_by_weight(:priority_letter_price, auctionable.weight)
      })
      auction.auctionable = auctionable
      auction
    end

  end

  def category_id
    auctionable.category_id_for_auction
  end

  def to_hash
    hash = attributes.symbolize_keys
    hash.delete :auctionable_id
    hash.delete :auctionable_type
    hash.delete :id
    hash[:buy_now_price] = hash.delete :price
    hash[:country_id]    = AlleApi::Client::COUNTRY_POLAND
    hash[:title]         = title
    hash[:category_id]   = category_id
    hash[:starts_at]     = created_at.to_datetime
    hash[:description]   = description
    hash[:duration]      = AlleApi.config[:default_duration]
    hash[:type]          = AlleApi.config[:default_type]

    hash
  end

  def to_allegro_auction
    AlleApi::Type::Auction.new(to_hash)
  end

  def description
    AlleApi.config[:description_renderer].call(self, auctionable)
  end

  def ends_at
    return nil unless published?

    published_at + 30.days
  end

  def inspect
    "<#{state}:#{id}:#{remote_id}>"
  end

  def url
    return unless remote_id.present?

    "http://allegro.pl/i#{remote_id}.html"
  end

  def finish_remote!
    account.api.finish_auction(remote_id)
  end
end

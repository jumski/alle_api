class AlleApi::AuctionTemplate < ActiveRecord::Base
  include AlleApi::AuctionSharedBehaviour

  has_many :auctions,
    foreign_key: :template_id,
    class_name: '::AlleApi::Auction',
    dependent: :destroy

  SHARED_ATTRIBUTES = %w(
    title price additional_info account account_id
    auctionable_id auctionable_type
    economic_package_price economic_letter_price
    priority_package_price priority_letter_price
  )
  ACCESSIBLE_ATTRIBUTES = SHARED_ATTRIBUTES.map(&:to_sym) +
    [:publishing_enabled, :auctionable, :auctionable_id, :auctionable_type, :finish_current_immediately]
  attr_accessor :finish_current_immediately

  attr_accessible *ACCESSIBLE_ATTRIBUTES

  after_update :finish_current_auction!, if: :finish_current_immediately
  before_destroy :disable_publishing!

  def consider_republication
    if current_auction
      Rails.logger.alle_api_debug.info("#consider_republication when current_auction => #{self}")
    end

    publish_next_auction if publishing_enabled?
  end

  def publish_next_auction
    spawn_auction.queue_for_publication!
  end

  def spawn_auction
    auctions.create(attributes.slice(*SHARED_ATTRIBUTES))
  end

  def disable_publishing!
    self.publishing_enabled = false
    save(validate: false)
  end

  def enable_publishing!
    self.publishing_enabled = true
    save(validate: false)
  end

  def end_publishing!
    disable_publishing!
    finish_current_auction!
  end

  def finish_current_auction!
    return unless current_auction

    current_auction.queue_for_finishing!
  end

  def current_auction
    last_auction if last_auction.try(:published?)
  end

  def last_auction
    auctions.last
  end

  def inspect
    "<##{id} enabled:#{publishing_enabled?}, published:#{current_auction.present?}>"
  end

end

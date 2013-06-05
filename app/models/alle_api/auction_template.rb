class AlleApi::AuctionTemplate < ActiveRecord::Base
  include AlleApi::AuctionSharedBehaviour

  has_many :auctions, foreign_key: :template_id, class_name: '::AlleApi::Auction'

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

  before_validation :steal_title_from_auctionable, unless: :title
  after_update :finish_current_auction!, if: :finish_current_immediately

  class << self
    def create_from_auction(auction)
      template = new(auction.attributes.slice(*SHARED_ATTRIBUTES))
      template.auctions << auction
      template.account = auction.account
      template.save!
      template
    end
  end

  def consider_republication
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
    save!
  end

  def enable_publishing!
    self.publishing_enabled = true
    save!
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

  private
    def steal_title_from_auctionable
      self.title = auctionable.title_for_auction
    end

end

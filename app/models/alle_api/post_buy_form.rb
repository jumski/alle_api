module AlleApi
  class PostBuyForm < ActiveRecord::Base
    attr_accessible :amount, :buyer_email, :buyer_id, :buyer_login, :invoice_requested, :message_to_seller, :payment_amount, :payment_cancelled_at, :payment_created_at, :payment_id, :payment_received_at, :payment_status, :payment_type, :postage_amount, :remote_id, :shipment_id, :source, :shipment_address

    belongs_to :account
    has_many :deal_events, primary_key: :remote_id, foreign_key: :remote_transaction_id
    has_and_belongs_to_many :auctions

    serialize :source
    serialize :shipment_address

    validates :remote_id, uniqueness: true

    def inspect
      "<PostBuyForm #{id} : #{payment_type} : #{payment_status}>"
    end

    def finished?
      payment_status.to_sym == :finished
    end
  end
end

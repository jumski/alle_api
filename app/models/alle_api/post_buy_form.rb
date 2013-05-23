module AlleApi
  class PostBuyForm < ActiveRecord::Base
    attr_accessible :amount, :buyer_email, :buyer_id, :buyer_login, :invoice_requested, :message_to_seller, :payment_amount, :payment_cancelled_at, :payment_created_at, :payment_id, :payment_received_at, :payment_status, :payment_type, :postage_amount, :remote_id, :shipment_id, :source, :shipment_address

    belongs_to :account

    serialize :source
    serialize :shipment_address
  end
end

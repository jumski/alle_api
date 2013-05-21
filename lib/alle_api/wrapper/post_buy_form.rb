module AlleApi
  module Wrapper
    class PostBuyForm < Base
      ATTRIBUTE_NAME_TRANSLATION = {
        id:              :remote_id,
        buyer_id:        :buyer_id,
        amount:          :items_amount,
        postage_amount:  :postage_amount,
        payment_amount:  :total_amount,
        invoice_option:  :requested_invoice,
        msg_to_seller:   :message_to_seller,
        pay_type:        :payment_type,
        pay_id:          :payment_id,
        pay_status:      :payment_status,
        date_init:       :payment_created_at,
        date_recv:       :payment_received_at,
        date_cancel:     :payment_cancelled_at,
        shipment_id:     :shipment_id,
        buyer_login:     :buyer_login,
        buyer_email:     :buyer_email,
      }

      attribute :remote_id, Integer
      attribute :buyer_id, Integer
      attribute :buyer_login, String
      attribute :buyer_email, String

      attribute :items_amount, Float
      attribute :postage_amount, Float
      attribute :total_amount, Float
      attribute :requested_invoice, Boolean
      attribute :message_to_seller, String

      attribute :payment_type, String
      attribute :payment_id, Integer
      attribute :payment_status, String
      attribute :payment_created_at, DateTime
      attribute :payment_received_at, DateTime
      attribute :payment_cancelled_at, DateTime

      attribute :shipment_id, Integer

      attribute :source, Hash

      class << self
        def key_prefix; 'post_buy_form_' end

        def wrap_multiple(multiple)
          # return empty array in case of nil multiple (no :item present)
          return [] unless multiple.present?

          # ensure our multiple is an array (for 1 multiple :item is a hash instead)
          super [multiple].flatten
        end

        def wrap(field)
          wrapped = super(field)
          wrapped.source = field
          wrapped
        end
      end

    end
  end
end

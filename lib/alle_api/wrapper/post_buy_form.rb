module AlleApi
  module Wrapper
    class PostBuyForm < Base
      ATTRIBUTE_NAME_TRANSLATION = {
        id: :remote_id,
        invoice_options: :invoice_requested,
        msg_to_seller: :message_to_seller,
        pay_type: :payment_type,
        pay_status: :payment_status,
        pay_id: :payment_id,
        date_init: :payment_created_at,
        date_recv: :payment_received_at,
        date_cancel: :payment_cancelled_at,
      }

      attribute :remote_id, Integer
      attribute :buyer_id, Integer
      attribute :buyer_login, String
      attribute :buyer_email, String

      attribute :amount, Float
      attribute :postage_amount, Float
      attribute :invoice_requested, Boolean
      attribute :message_to_seller, String

      attribute :payment_type, String
      attribute :payment_id, Integer
      attribute :payment_status, String
      attribute :payment_created_at, DateTime
      attribute :payment_received_at, DateTime
      attribute :payment_cancelled_at, DateTime
      attribute :payment_amount, Float

      attribute :shipment_id, Integer
      attribute :source, Hash

      attribute :shipment_address, Hash

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
          wrapped.source = field.to_hash
          wrapped
        end
      end

      %w(created received cancelled).each do |type|
        define_method "payment_#{type}_at=" do |date|
          date = nil if date.is_a? Hash
          super(date)
        end
      end

      def shipment_address
        @shipment_address_wrapped ||= Wrapper::ShipmentAddress.wrap(super)
      end

      def create_post_buy_form(account)
        attrs = attributes
        attrs.delete :shipment_address
        AlleApi::PostBuyForm.create attrs
      end

    end
  end
end

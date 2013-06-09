# encoding: utf-8
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
          wrapped.source = field
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

      def create_if_missing(account)
        unless post_buy_form = account.post_buy_forms.find_by_remote_id(remote_id)
          attrs = attributes
          attrs.delete :shipment_address
          attrs[:shipment_address] = shipment_address.to_hash

          post_buy_form = AlleApi::PostBuyForm.new(attrs)
          post_buy_form.account = account
          post_buy_form.auctions = AlleApi::Auction.where(remote_id: remote_auction_ids)
          post_buy_form.save!
        end

        post_buy_form
      end

      def payment_type
        case super
        when 'co' then :payu_checkout
        when 'ai' then :payu_installments
        when 'collect_on_delivery' then :collect_on_delivery
        end
      end

      def message_to_seller
        return if super == "---\n:@xsi:type: xsd:string\n"

        super
      end

      def payment_status
        case super
        when 'Rozpoczęta' then :started
        when 'Anulowana'  then :cancelled
        when 'Odrzucona'  then :rejected
        when 'Zakończona' then :finished
        when 'Wycofana'   then :withdrawn
        end
      end

      def remote_auction_ids
        items = [ source[:post_buy_form_items][:item] ].flatten

        items.map { |item| item[:post_buy_form_it_id].to_i }
      end

    end
  end
end

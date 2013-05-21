module AlleApi
  module Wrapper
    class PostBuyForm < Base
      ATTRIBUTE_NAME_TRANSLATION = {}

      attribute :id, Integer
      attribute :buyer_id, Integer
      attribute :buyer_login, String
      attribute :buyer_email, String

      attribute :amount, Float
      attribute :postage_amount, Float
      attribute :invoice_options, Boolean
      attribute :msg_to_seller, String

      attribute :pay_type, String
      attribute :pay_id, Integer
      attribute :pay_status, String
      attribute :date_init, DateTime
      attribute :date_recv, DateTime
      attribute :date_cancel, DateTime
      attribute :payment_amount, Float

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

      %w(init cancel recv).each do |type|
        define_method "date_#{type}=" do |date|
          date = nil if date.is_a? Hash
          super(date)
        end
      end

    end
  end
end

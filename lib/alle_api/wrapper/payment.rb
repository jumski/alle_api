module AlleApi
  module Wrapper
    class Payment < Base
      ATTRIBUTE_NAME_TRANSLATION = {
        id: :remote_id,
        it_id: :remote_auction_id,
        create_date: :created_at,
        recv_date:   :received_at,
        main_id: :parent_remote_id,
        incomplete: :incompleted
      }

      attribute :remote_id, Integer
      attribute :remote_auction_id, Integer
      attribute :buyer_id, Integer
      attribute :type, String
      attribute :status, String
      attribute :amount, Float
      attribute :postage_amount, Float
      attribute :created_at, DateTime
      attribute :received_at, DateTime
      attribute :price, Float
      attribute :count, Integer
      attribute :details, String
      attribute :incompleted, Integer
      attribute :parent_remote_id, Integer
      attribute :source, Hash

      class << self
        def key_prefix; 'pay_trans_' end

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

      def completed
        incompleted == 0
      end

      def parent_remote_id
        value = super
        return nil unless value > 0

        value
      end

      def details
        nil
      end

      %w(created received).each do |type|
        define_method "#{type}_at=" do |date|
          super Time.at(date.to_i).to_datetime
        end
      end

      def create_payment(account)
        attrs = attributes.with_indifferent_access
        attrs[:kind] = attrs.delete :type
        attrs[:completed] = completed
        attrs.delete :incompleted

        AlleApi::Payment.create attrs
      end
    end
  end
end

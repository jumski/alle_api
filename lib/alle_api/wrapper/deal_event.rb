module AlleApi
  module Wrapper
    class DealEvent < Base
      ATTRIBUTE_NAME_TRANSLATION = {
        deal_event_id: :remote_id,
        deal_item_id: :remote_auction_id,
        deal_event_time: :occured_at,
        deal_seller_id: :remote_seller_id,
        deal_buyer_id: :remote_buyer_id,
        deal_id: :remote_deal_id,
        deal_quantity: :quantity,
        deal_transaction_id: :remote_transaction_id,
        deal_event_type: :kind,
      }

      attribute :remote_id, Integer
      attribute :remote_auction_id, Integer
      attribute :occured_at, DateTime
      attribute :remote_seller_id, Integer
      attribute :remote_buyer_id, Integer
      attribute :remote_deal_id, Integer
      attribute :remote_transaction_id, Integer
      attribute :kind, String
      attribute :quantity, Integer
      attribute :kind, Integer

      class << self
        def wrap_multiple(multiple)
          # return empty array in case of nil multiple (no :item present)
          return [] unless multiple.present?

          # ensure our multiple is an array (for 1 multiple :item is a hash instead)
          multiple = [multiple].flatten

          super(multiple)
        end
      end

      def occured_at=(time_object)
        super(Time.at(time_object.to_s.to_i).to_datetime)
      end

      def model_klass
        case kind
        when 1 then AlleApi::DealEvent::NewDeal
        when 2 then AlleApi::DealEvent::NewTransaction
        when 3 then AlleApi::DealEvent::CancelTransaction
        when 4 then AlleApi::DealEvent::FinishTransaction
        end
      end

      # def create_auction_event(account)
      #   auction = AlleApi::Auction.find_by_remote_id(remote_auction_id)

      #   unless event = model_klass.find_by_remote_id(remote_id)
      #     attribs = {
      #       remote_id: remote_id,
      #       remote_auction_id: remote_auction_id,
      #       remote_seller_id: remote_seller_id,
      #       current_price: current_price,
      #       occured_at: occured_at,
      #       account_id: account.id
      #     }

      #     if auction.present?
      #       attribs[:auction_id] = auction.id
      #     end

      #     event = model_klass.create(attribs)
      #   end

      #   event
      # end
    end
  end
end

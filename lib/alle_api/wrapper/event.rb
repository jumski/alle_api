
module AlleApi
  module Wrapper
    class Event < Base
      ATTRIBUTE_NAME_TRANSLATION = {
        row_id:          :remote_id,
        item_id:         :remote_auction_id,
        item_seller_id:  :remote_seller_id,
        current_price:   :current_price,
        change_date:     :occured_at,
        change_type:     :kind
      }

      attribute :remote_id, Integer
      attribute :remote_auction_id, Integer
      attribute :remote_seller_id, Integer
      attribute :current_price, Float
      attribute :occured_at, DateTime
      attribute :kind, String

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
        when 'start'  then AlleApi::AuctionEvent::Start
        when 'end'    then AlleApi::AuctionEvent::End
        when 'now'    then AlleApi::AuctionEvent::BuyNow
        when 'change' then AlleApi::AuctionEvent::Update
        end
      end

      def create_auction_event(account)
        auction = AlleApi::Auction.find_by_remote_id(remote_auction_id)

        unless event = model_klass.find_by_remote_id(remote_id)
          attribs = {
            remote_id: remote_id,
            remote_auction_id: remote_auction_id,
            remote_seller_id: remote_seller_id,
            current_price: current_price,
            occured_at: occured_at,
            account_id: account.id
          }

          if auction.present?
            attribs[:auction_id] = auction.id
          end

          event = model_klass.create(attribs)
        end

        event
      end

      # def trigger
      #   return unless auction

      #   unless auction.valid?
      #     raise AlleApi::CannotTriggerEventOnInvalidAuctionError.new(auction, self)
      #   end

      #   begin
      #     case kind
      #     when :auction_end
      #       auction.end!
      #       return
      #     when :auction_buy_now
      #       auction.buy_now!
      #       return
      #     end
      #   rescue Workflow::NoTransitionAllowed
      #     # we accept that
      #   end
      # end

    end
  end
end

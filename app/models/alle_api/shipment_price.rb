module AlleApi
  class ShipmentPrice
    TYPES = %w(priority_package_price priority_letter_price
               economic_letter_price economic_package_price)

    def self.all_for_weight(weight)
      prices = {}

      TYPES.each do |type|
        prices[type] = AlleApi::Auction.shipment_price_by_weight(type, weight)
      end

      prices
    end
  end
end

module AlleApi
  module Wrapper
    class ShipmentAddress < Base
      ATTRIBUTE_NAME_TRANSLATION = {
        adr_street:     :address_1,
        adr_postcode:   :zipcode,
        adr_phone:      :phone_number,
        created_date:   :created_at,
        adr_type:       :type,
        adr_country:    :country_id,
        adr_city:       :city,
        adr_full_name:  :full_name,
      }

      attribute :country_id, Integer
      attribute :address_1, String
      attribute :zipcode, String
      attribute :city, String
      attribute :full_name, String
      attribute :company, String
      attribute :phone_number, String
      attribute :created_at, DateTime
      attribute :type, Integer

      class << self
        def key_prefix; 'post_buy_form_' end
      end

      def country
        return nil unless country_id == 1

        'Polska'
      end
    end
  end
end

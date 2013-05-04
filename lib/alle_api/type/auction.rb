# encoding: utf-8

module AlleApi
  module Type
    class Auction
      include Virtus

      # :desc=>"3|5|7|10|14|30",
      # :opts_values=>"0|1|2|3|4|5","
      DURATION_3 = 0
      DURATION_5 = 1
      DURATION_7 = 2
      DURATION_10 = 3
      DURATION_14 = 4
      DURATION_30 = 5

      BUYER  = 1
      SELLER = 0

      CONDITION_NEW = 1
      CONDITION_USED = 2

      TYPE_AUCTION = 0
      TYPE_SHOP = 1

      attribute :amount,                Integer, default: 1
      attribute :category_id,           Integer
      attribute :country_id,            Integer
      attribute :delivery_methods,      Integer, default: 1 + 2 + 4 + 8
      attribute :duration,              Integer, default: DURATION_30
      attribute :free_delivery_methods, Integer, default: 1
      attribute :payment_methods,       Integer, default: 1
      # testwebapi region default
      # attribute :region,                Integer, default: 213
      attribute :region,                Integer, default: 6 # małopolska
      attribute :type,                  Integer, default: TYPE_SHOP
      attribute :covers_delivery_costs, Integer, default: BUYER
      attribute :condition,             Integer, default: CONDITION_USED

      attribute :buy_now_price,          Float, default: 0
      attribute :economic_letter_price,  Float
      attribute :economic_package_price, Float
      attribute :price,                  Float, default: 0
      attribute :priority_letter_price,  Float
      attribute :priority_package_price, Float

      attribute :title,       String
      attribute :description, String
      attribute :place,       String, default: 'Kraków'
      attribute :zip_code,    String, default: '31-610'

      attribute :starts_at, DateTime

      EMPTY_HASH = {
        'fid'             => nil,
        'fvalue-string'   => '',
        'fvalue-int'      => 0,
        'fvalue-float'    => 0,
        'fvalue-image'    => ' ',
        'fvalue-datetime' => 0,
        'fvalue-boolean'  => false,
      }

      CLASS_TO_FVALUE_KEY = {
        String                    => 'fvalue-string',
        ActiveSupport::SafeBuffer => 'fvalue-string',
        Fixnum                    => 'fvalue-int',
        Integer                   => 'fvalue-int',
        Float                     => 'fvalue-float',
        DateTime                  => 'fvalue-datetime',
        TrueClass                 => 'fvalue-boolean',
        FalseClass                => 'fvalue-boolean',
      }

      ATTRIBUTE_TO_FID = {
        title: 1,
        category_id: 2,
        starts_at: 3,
        duration: 4,
        amount: 5,
        price: 7,
        buy_now_price: 8,
        country_id: 9,
        region: 10,
        place: 11,
        covers_delivery_costs: 12,
        delivery_methods: 13,
        free_delivery_methods: 35,
        payment_methods: 14,
        description: 24,
        zip_code: 32,
        economic_package_price: 36,
        priority_package_price: 38,
        economic_letter_price: 41,
        priority_letter_price: 43,
        type: 29,
        # condition: it will be determined dynamically
        #            based on fid for specific category, look here:
        #            http://allegro.pl/webapi/news.php/page,2#news_350
      }

      def valid?
        true # this sux, i know, someday this will be a real method!
      end

      class << self
        def attribute_to_hash(attribute, value, category_id = nil)
          attribute = attribute.to_sym

          hash = EMPTY_HASH.dup
          hash['fid'] = fid_for_attribute(attribute, category_id)

          key = CLASS_TO_FVALUE_KEY[value.class]
          value = value.to_i if value.kind_of? DateTime
          hash[key] = value

          hash
        end

        def fid_for_attribute(attribute, category_id = nil)
          return ATTRIBUTE_TO_FID[attribute] unless category_id

          return fid_for_condition(category_id)
        end

        def fid_for_condition(category_id)
          ::AlleApi::Category.find(category_id).fid_for_condition
        end
      end

      def to_fields_array
        fields = []

        attributes.each do |attribute, value|
          if attribute.to_sym == :condition
            fields << self.class.attribute_to_hash(attribute, value, self.category_id)
          else
            fields << self.class.attribute_to_hash(attribute, value)
          end
        end

        fields
      end
    end
  end
end

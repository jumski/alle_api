
module AlleApi
  module Wrapper
    class Base
      include Virtus

      class << self
        def wrap_multiple(result)
          result.map { |field| wrap(field) }
        end

        def wrap(field)
          attributes = {}

          field.each do |original, value|
            translated = self::ATTRIBUTE_NAME_TRANSLATION[original]
            attributes[translated] = value
          end

          new(attributes)
        end
      end
    end
  end
end

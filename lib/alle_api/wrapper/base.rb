
module AlleApi
  module Wrapper
    class Base
      include Virtus

      class << self
        def key_prefix; false end

        def wrap_multiple(result)
          result.map { |field| wrap(field) }
        end

        def wrap(field)
          attributes = {}

          field.each do |original, value|
            original = original.to_s.gsub(key_prefix, '').to_sym if key_prefix

            translated = self::ATTRIBUTE_NAME_TRANSLATION[original] || original
            attributes[translated] = value
          end

          new(attributes)
        end
      end
    end
  end
end


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

        def nil_values
          @nil_values ||= [
            "---\n:@xsi:type: xsd:string\n",
            {:"@xsi:type"=>"xsd:string"},
            {:"@xsi:type"=>"xsd:string"}.with_indifferent_access
          ]
        end

        # TODO: convert to custom virtus attribute
        #       with a writer class when gem-ctags
        #       will be fixed and virtus 1.0 installable
        def convert_nil_hash_to_nil_for(attrib)
          define_method attrib do
            return if self.class.nil_values.include? super()

            super()
          end
        end
      end
    end
  end
end

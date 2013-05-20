module AlleApi
  module Wrapper
    class PostBuyForm < Base
      ATTRIBUTE_NAME_TRANSLATION = {
        post_buy_form_id: :remote_id,
      }

      attribute :remote_id, Integer
      attribute :source, Hash

      class << self
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

    end
  end
end

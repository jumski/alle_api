
module AlleApi
  class Field < ActiveRecord::Base
    include ::AlleApi::SoftRemovable

    CONDITION_FIELD_NAME = 'Stan'

    belongs_to :category, class_name: "AlleApi::Category"

    attr_accessible :category_id, :default_value, :description, :form_type, :max_length, :max_value, :min_value, :name, :options, :options_descriptions, :options_values, :param_id, :param_values, :parent_param_id, :parent_param_value, :position, :request_type, :required, :unit

    class << self
      def create_from_allegro(attributes)
        id = attributes.delete :id
        category_id = attributes.delete :category_id

        field = new(attributes)
        field.id = id
        field.category_id = category_id if category_id > 0
        field.save!
        field
      end
    end

    def condition_field?
      name == CONDITION_FIELD_NAME
    end

  end
end

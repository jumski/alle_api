
module AlleApi
  module Wrapper
    class Field < Base
      ATTRIBUTE_NAME_TRANSLATION =  {
        sell_form_id:            :id,
        sell_form_title:         :name,
        sell_form_cat:           :category_id,
        sell_form_type:          :form_type,
        sell_form_res_type:      :request_type,
        sell_form_def_value:     :default_value,
        sell_form_opt:           :required,
        sell_form_pos:           :position,
        sell_form_length:        :max_length,
        sell_min_value:          :min_value,
        sell_max_value:          :max_value,
        sell_form_desc:          :options_descriptions,
        sell_form_opts_values:   :options_values,
        sell_form_field_desc:    :description,
        sell_form_param_id:      :param_id,
        sell_form_param_values:  :param_values,
        sell_form_parent_id:     :parent_param_id,
        sell_form_parent_value:  :parent_param_value,
        sell_form_unit:          :unit,
        sell_form_options:       :options,
      }

      ATTRIBUTES = ATTRIBUTE_NAME_TRANSLATION.values
      ATTRIBUTES.each do |name|
        type = String
        type = Float   if name.to_s =~ /(min|max|length)/
        type = Integer if name.to_s.include?('id')

        attribute name, type
      end
    end
  end
end

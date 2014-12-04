
module AlleApi::Action
  class GetFieldsForCategory < Base
    def soap_action
      :do_get_sell_form_fields_for_category
    end

    def request_body(category_id)
      { webapi_key:  client.webapi_key,
        country_id:  client.country_id,
        category_id: category_id.to_i }
    end

    def extract_results(result)
      items = extract_items(result)
      AlleApi::Wrapper::Field.wrap_multiple(items)
    end

    def extract_items(result)
      result[:sell_form_fields_for_category][:sell_form_fields_list][:item]
    end
  end
end


module AlleApi::Action
  class GetCategories < Base
    def soap_action
      :do_get_cats_data
    end

    def request_body
      { country_id: client.country_id,
        local_version: client.version_key,
        webapi_key: client.webapi_key }
    end

    def extract_results(result)
      result[:cats_list][:item].map do |item|
        { id:        item[:cat_id].to_i,
          parent_id: item[:cat_parent].to_i,
          name:      item[:cat_name].to_s,
          position:  item[:cat_position].to_i }
      end
    end
  end
end

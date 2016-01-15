
module AlleApi::Action
  class FinishAuctions < Base
    def soap_action
      :do_finish_items
    end

    def validate!(remote_ids)
      if remote_ids.blank?
        raise ValidationError, 'Please provide remote ids'
      end

      if remote_ids.length > 25
        raise ValidationError, 'Cannot finish more than 25 auctions at once'
      end
    end

    def request_body(remote_ids)
      Rails.logger.alle_api_debug.info "remote_ids = #{remote_ids}"
      {
        session_handle: client.session_handle,
        finish_items_list: {
          item: remote_ids.map { |id|
            { finish_item_id:         id,
              finish_cancel_all_bids: 0,
              finish_cancel_reason:   '' }
            }
        }
      }.tap do |hash|
        Rails.logger.alle_api_debug.info "request_body = #{hash}"
      end
    end

    def extract_results(result)
      Rails.logger.alle_api_debug "result = #{result}"
      {
        finished: [result[:finish_items_succeed][:item]].flatten.map(&:to_i),
        failed: []
      }.tap do |hash|
        Rails.logger.alle_api_debug "extract_results = #{hash}"
      end
    end
  end
end


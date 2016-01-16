
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
      {
        session_handle: client.session_handle,
        finish_items_list: {
          item: remote_ids.map { |id|
            { finish_item_id:         id,
              finish_cancel_all_bids: 0,
              finish_cancel_reason:   '' }
            }
        }
      }
    end

    def extract_results(result)
      {
        finished: [result[:finish_items_succeed][:item]].flatten.map(&:to_i),
        failed: []
      }
    end
  end
end


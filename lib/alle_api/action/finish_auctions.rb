
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
        'session-handle' => client.session_handle,
        'finish-items-list' => {
          'finish-items-list' => remote_ids.map { |id|
            { 'finish-item-id'         => id,
              'finish-cancel-all-bids' => 0,
              'finish-cancel-reason'   => '' }
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


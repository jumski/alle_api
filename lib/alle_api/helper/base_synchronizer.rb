
module AlleApi
  module Helper
    class BaseSynchronizer
      attr_reader :api

      def initialize(api)
        @api = api
      end

      def component;   not_yet end
      def model_klass; not_yet end
      def api_action;  not_yet end
      def clean
        # i do nothing :)
      end

      def synchronize!
        synchronize
        AlleApi.versions.update(component)
      end

      def synchronize
        model_klass.transaction do
          import_added
          soft_remove_removed
          clean
        end
      end

      def import_added
        added.each do |item|
          model_klass.create_from_allegro(item.to_hash)
        end
      end

      def soft_remove_removed
        ids = removed.map(&:id)
        model_klass.where(id: ids).update_all(
          soft_removed_at: DateTime.now.in_time_zone
        )
      end

      def added
        new_ids = allegro_ids - local_ids

        allegro_items.select do |item|
          new_ids.include? item[:id]
        end
      end

      def removed
        model_klass.where('id NOT IN (?)', allegro_ids)
      end

      private
        def allegro_items
          @allegro_items ||= api.send(api_action)
        end

        def local_ids
          model_klass.pluck(:id)
        end

        def allegro_ids
          @allegro_ids ||= allegro_items.map do |item|
            item[:id]
          end
        end

        def not_yet
          raise "Please implement me!"
        end
    end
  end
end

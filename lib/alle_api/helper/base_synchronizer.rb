
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
          imported = import_added
          removed = soft_remove_removed
          clean

          imported_handler.call(imported) if imported_handler
          removed_handler.call(removed) if removed_handler
        end
      end

      def import_added
        raise "Cannot call #import_added twice!" if @import_added_called

        added = self.added.map do |item|
          model_klass.create_from_allegro(item.to_hash)
        end
        @import_added_called = true

        added
      end

      def soft_remove_removed
        raise 'Cannot call #soft_remove_removed twice!' if @soft_remove_removed_called

        to_soft_remove = model_klass.where(id: removed.map(&:id))
        to_soft_remove.update_all(soft_removed_at: DateTime.now.in_time_zone)
        @soft_remove_removed_called = true

        to_soft_remove
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
        def imported_handler
          config.imported_handler
        end

        def removed_handler
          config.removed_handler
        end

        def config
          AlleApi.config.send("#{component}!")
        end

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

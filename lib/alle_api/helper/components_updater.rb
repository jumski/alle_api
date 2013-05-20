
module AlleApi
  module Helper
    class ComponentsUpdater
      def update!
        versions.update(:version_key)

        if versions.changed?(:fields)
          AlleApi::Job::UpdateFields.perform_async
        end

        if versions.changed?(:categories_tree)
          AlleApi::Job::UpdateCategoriesTree.perform_async
        end
      end

      def versions
        @versions ||= Versions.new
      end

    end
  end
end

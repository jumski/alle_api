
module AlleApi
  module Helper
    class CategoryTreeSynchronizer < BaseSynchronizer

      def component;   :categories_tree  end
      def model_klass; AlleApi::Category end
      def api_action;  :get_categories   end

      def clean
        model_klass.assign_proper_parents!
        model_klass.update_leaf_nodes!
        model_klass.update_path_texts!
        model_klass.cache_condition_field!
      end

    end
  end
end

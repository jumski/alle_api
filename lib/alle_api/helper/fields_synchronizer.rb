
module AlleApi
  module Helper
    class FieldsSynchronizer < BaseSynchronizer

      def component;   :fields        end
      def model_klass; AlleApi::Field end
      def api_action;  :get_fields    end

    end
  end
end

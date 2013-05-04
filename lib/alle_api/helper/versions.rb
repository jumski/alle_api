
module AlleApi
  module Helper
    class Versions
      def update_version_of(component)
        self[component] = allegro_versions[component]
      end

      def [](component)
        redis.get(key_for(component))
      end

      def []=(component, version)
        redis.set(key_for(component), version)
      end

      def changed?(component)
        self[component] != allegro_versions[component]
      end

      private
        def key_for(component)
          "versions:#{component}"
        end

        def allegro_versions
          @allegro_versions ||= AlleApi.utility_api.get_versions
        end

        def redis
          AlleApi.redis
        end
    end
  end
end

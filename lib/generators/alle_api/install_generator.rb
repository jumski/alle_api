
module AlleApi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Copies alle_api migrations and initializer to host application"

      def copy_initializer
        template "alle_api.rb", "config/initializers/alle_api.rb"
      end

      def copy_config
        template "alle_api.yml", "config/alle_api.yml"
      end

      # Coping migrations
      def copy_migrations
        silence_stream(STDOUT) do
          silence_warnings { rake 'alle_api:install:migrations' }
        end
      end

      # Print installation informations
      def finish_info
        readme "README" if behavior == :invoke
      end
    end
  end
end

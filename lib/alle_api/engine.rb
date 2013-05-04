module ::AlleApi
  class Engine < ::Rails::Engine
    isolate_namespace AlleApi

    config.generators do |g|
      g.javascripts false
      g.stylesheets false
      g.helper false
      g.integration_tool false

      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl,
        :dir => 'spec/factories/'
    end

    # needed for multi-threaded enviromnent (sidekiq)
    config.eager_load_paths += ["#{config.root}/lib/alle_api"]

    initializer "model_core.factories", :after => "factory_girl.set_factory_paths" do
      if defined?(FactoryGirl)
        path = File.expand_path('../../../spec/factories', __FILE__)
        FactoryGirl.definition_file_paths << path
      end
    end
  end
end

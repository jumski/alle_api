
module AlleApi
  class Config
    cattr_writer :yaml_path

    def self.[](key)
      @configs ||= Hashie::Mash.new(load_config)
      @configs[key]
    end

    def self.load_config
      erb = ERB.new(File.read(yaml_path))
      YAML.load(erb.result)
    end

    def self.yaml_path
      @yaml_path ||= begin
                       if Rails.env.test? || Rails.env.development?
                         ENV['ALLE_API_CONFIG_PATH']
                       else
                         Rails.root.join('config/alle_api.yml')
                       end
                     end
    end
  end
end

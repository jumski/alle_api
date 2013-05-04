
module AlleApi
  class Client < Savon::Client
    COUNTRY_POLAND = 1

    attr_accessor :webapi_key, :version_key, :login, :password, :country_id

    def initialize(options)
      @login      = options[:login]
      @password   = options[:password]
      @webapi_key = options[:webapi_key]
      @version_key = options[:version_key]
      @session_handle = options[:session_handle]
      @country_id  = COUNTRY_POLAND

      super() do
        wsdl.document = File.expand_path(File.dirname(__FILE__) + '/../../assets/allegro.wsdl')
      end
    end

    def session_handle
      AlleApi.redis.get("client:#{login}:session_handle")
    end

    def session_handle=(handle)
      AlleApi.redis.setex("client:#{login}:session_handle", 55.minutes, handle)
    end
  end
end

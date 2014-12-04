
module AlleApi
  class Client
    COUNTRY_POLAND = 1
    INVALID_SESSION_ERROR = 'ERR_NO_SESSION'

    attr_accessor :webapi_key, :version_key, :login, :password, :country_id
    cattr_accessor :enable_savon_output

    def self.with_silent_output
      raise "Please provide block!" unless block_given?

      self.enable_savon_output = false
      yield
    ensure
      self.enable_savon_output = true
    end

    def initialize(options)
      @login          = options[:login]
      @password       = options[:password]
      @webapi_key     = options[:webapi_key]
      @version_key    = options[:version_key]
      @session_handle = options[:session_handle]
      @country_id     = COUNTRY_POLAND
    end

    def api
      @api ||= Api.new(self)
    end

    def request(action, params)
      begin
        client.call(action, message: params)
      rescue Savon::SOAPFault => e
        if e.message.include? INVALID_SESSION_ERROR
          params[:session_handle] = refresh_session_handle!
          retry
        end

        raise
      end
    end

    def session_handle
      current_handle = AlleApi.redis.get("client:#{login}:session_handle")
      return current_handle if current_handle.present?

      refresh_session_handle!
    end

    def session_handle=(handle)
      AlleApi.redis.setex("client:#{login}:session_handle", 55.minutes, handle)
    end

    def client
      @client ||= Savon.client(client_options)
    end

    private

    def refresh_session_handle!
      self.session_handle = api.authenticate
    end

    def client_options
      {
        wsdl: wsdl_url,
        open_timeout: 5.minutes,
        read_timeout: 5.minutes,

        pretty_print_xml: !!self.class.enable_savon_output,
        strip_namespaces: true,
        log: !!self.class.enable_savon_output,
        log_level: :debug,

        convert_request_keys_to: :lower_camelcase
      }
    end

    def wsdl_url
      if AlleApi.config.sandbox
        'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl'
      else
        'https://webapi.allegro.pl/service.php?wsdl'
      end
    end

  end
end

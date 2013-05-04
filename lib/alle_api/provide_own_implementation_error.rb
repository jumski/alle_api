
module AlleApi
  class ProvideOwnImplementationError < RuntimeError
    def initialize(method_name, klass)
      @method_name = method_name
      @klass = klass
    end

    def message
      "Please implement `#@method_name` on #@klass in order to use AlleApi"
    end

  end
end

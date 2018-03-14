module SFKB
  # Some REST helpers
  module REST
    # Used to interpolate variables into REST endpoint URIs
    @@placeholder = /[<{](.+?)[>}]/

    # { a: :b }.inject({}, &@@stringify) #=> { 'a' => :b }
    @@stringify = lambda do |collector, kv|
      collector.tap { |h| h[kv[0].to_s] = kv[1] }
    end

    # { a: 1 }.delete(:b, &@@required) # raises 'missing param: b'
    @@required = -> (s) { raise(ArgumentError, "missing param: <#{s}>") }

    # { a: b, c: d }.inject('x', &@@parameterize) #=> 'x?a=b&c=d'
    @@parameterize = lambda do |s, kv|
      k, *vs = *kv
      params = vs.flatten.map { |v| [k, v].join('=') }
      [s, params].flatten.compact.reject(&:empty?).join('&')
    end

    # Converts a path and params to a Salesforce-suitable URL.
    def url(path, params = {})
      params = params.inject({}, &@@stringify)
      path = path.gsub(@@placeholder) { params.delete($1, &@@required) }
      params = params.inject('', &@@parameterize)
      [path, params].reject(&:nil?).reject(&:empty?).join('?')
    end

    # The REST API starts here
    def index
      endpoint("/services/data/v#{options[:api_version]}") do |k, v|
        endpoint(v) { |k, v| endpoint(v) }
      end
    end
   
    # Fetches the object at url, and extends it with methods
    def endpoint(url)
      get(url).body.tap do |o|
        o.each do |k, v|
          o.define_singleton_method(k) do
            ivar = :"@#{k}"
            return instance_variable_get(ivar) if instance_variable_defined?(ivar)
            instance_variable_set(ivar, block_given? ? yield(k, v) : v)
          end
        end
      end
    end

    extend self
  end
end

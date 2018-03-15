module SFKB
  # Some REST helpers
  module REST
    # Used to interpolate variables into REST endpoint URIs
    @@placeholder = /[<{](.+?)[>}]/.freeze

    # Used to identify URLs; %s should be the api_version
    @@url_pattern = '/services/data/v%s'.freeze

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

    # The starting URL
    def services_url
      @@url_pattern % options[:api_version]
    end

    # The REST API starts here
    def index
      endpoint(get(services_url).body)
    end

    # endpoint takes a map, and for eack key/value pair, adds a singleton
    # method to the map which will fetch that resource (if it looks like a
    # URL).
    def endpoint(map)
      map.each { |k, v| apply_endpoint(map, k, v) }
      map
    end

    # applies an endpoint to obj, named k, which fetches v and makes it an
    # endpoint if it looks like a URL
    def apply_endpoint(obj, k, v)
      α = -> { endpoint(get(v).body) }
      β = -> { v }
      λ = url?(v) ? -> { α.call } : -> { β.call }
      obj.define_singleton_method(k, &λ) if url?(v)
      obj
    end

    # Identifies a valid URL for this REST instance
    def url?(string)
      return false unless string.to_s =~ url_pattern
      return false if     string.to_s =~ @@placeholder
      true
    end

    # Identifies a valid URL for this REST instance
    def url_pattern
      %r{#{services_url}}
    end

    extend self
  end
end

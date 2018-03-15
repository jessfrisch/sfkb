module SFKB
  # Methods to smartly apply singleton methods to REST objects
  module Decoration
    def decorate(object)
      return object unless block_given?
      yield object
      object
    end

    def define_link(object, name, url, &block)
      getter = -> (url) { get(url).body }
      decorator = -> (o) { decorate(o, &block) }
      object.define_singleton_method(name) { decorator.call(getter.call(url)) }
    end

    def define_links(object, urls, &block)
      urls.each { |k, v| define_link(object, k, v, &block) }
    end

    def define_predicate(object, name, value)
      object.define_singleton_method(:"#{name}?") { value }
    end

    def autodefine(object)
      return unless object.respond_to?(:additionalInformation)
      return unless info = object.additionalInformation
      autodefine_data(object, info[:data])
      autodefine_links(object, info[:urls])
      autodefine_predicates(object, info)
      object
    end

    def autodefine_predicates(object, predicates)
      predicates.each do |k, v|
        next unless [true, false].include?(v)
        define_predicate(object, k, v)
      end
      object
    end

    def autodefine_data(object, data)
      return object if data.nil?
      define_link(object, :data, data)
      object
    end

    def autodefine_links(object, urls)
      return if urls.nil?
      define_links(object, urls) { |o| autodefine(o) }
      object
    end
  end
end

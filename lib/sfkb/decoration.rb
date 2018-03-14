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
      info.each do |k, v|
        if [true, false].include?(v)
          define_predicate(object, k, v)
        elsif k.to_s == 'data'
          define_link(object, :data, v)
        elsif k.to_s == 'urls'
          define_links(object, v) { |o| autodefine(o) }
        end
      end
      object
    end
  end
end

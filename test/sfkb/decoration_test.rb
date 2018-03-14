require 'test_helper'
require 'sfkb/decoration'

describe SFKB::Decoration do
  include SFKB::Decoration

  describe 'decorate(String)' do
    it 'returns the string' do
      assert_equal 'a', decorate('a')
    end

    it 'yields the string' do
      decorate('a') do |x|
        assert_equal 'a', x
      end
    end
  end

  describe 'decorate({x: y})' do
    it 'returns the hash' do
      assert_equal({ x: :y }, decorate(x: :y))
    end
  end

  describe 'define_link(obj, name, url)' do
    it 'defines a getter method for the link' do
      foo = 'hi'
      define_singleton_method(:get) { |x| OpenStruct.new(body: 'Found me') }
      define_link(foo, 'bar', '/baz')
      assert_respond_to foo, :bar
      assert_equal "Found me", foo.bar
    end
  end

  describe 'define_predicate(obj, name, value)' do
    it 'defines a predicate method for value' do
      foo = 'hi'
      define_predicate(foo, 'bar', true)
      define_predicate(foo, 'baz', false)
      assert foo.bar?
      refute foo.baz?
    end
  end

  describe 'define_links(obj, { a: "/l1", b: "/l2" })' do
    it 'links all urls to those names' do
      foo = 'hi'
      define_links(foo, { a: '/l1', b: '/l2' })
      define_singleton_method(:get) { |x| OpenStruct.new(body: "I was at #{x}!") }
      assert_equal 'I was at /l1!', foo.a
      assert_equal 'I was at /l2!', foo.b
    end
  end

  describe 'autodefine' do
    let(:foo) { OpenStruct.new(additionalInformation: { isTall: true, isFat: false, urls: { a: '/l1' }, data: '/l3' }) }
    it 'uses additionalInformation' do
      define_singleton_method(:get) { |x| OpenStruct.new(body: "I was at #{x}!") }
      autodefine(foo)
      assert foo.isTall?
      refute foo.isFat?
      assert_equal 'I was at /l1!', foo.a
      assert_equal 'I was at /l3!', foo.data
    end
  end
end

require 'test_helper'
require 'sfkb/rest'

describe SFKB::REST do
  include SFKB::REST
  let(:options) { { api_version: 'X' } }
  let(:response) { |x| OpenStruct.new(body: x) }

  describe 'url' do
    it 'joins paths to params amd substitutes vars' do
      assert_equal '/foo', url('/foo')
      assert_equal '/foo?x=1', url('/foo', x: 1)
      assert_equal '/foo?x=1&y=2', url('/foo', x: 1, y: 2)
    end

    it 'substitutes vars' do
      assert_equal '/foo/1/2', url('/foo/<x>/<y>', x: 1, y: 2)
      assert_equal '/foo/1?y=2', url('/foo/<x>', x: 1, y: 2)
      assert_equal '/a/1?b=2&b=3&c=4', url('/a/<a>', a: 1, b: %w(2 3), c: 4)
      assert_raises { url('/x/<blah>') }
    end
  end

  describe 'index' do
    let(:services) { { 'a' => '/services/data/vX/a', 'b' => { foo: 123 } } }
    let(:responses) do
      {
        '/services/data/vX'   => services,
        '/services/data/vX/a' => { 'b' => '/services/data/vX/b' },
        '/services/data/vX/b' => { 'c' => '/services/data/vX/c' },
        '/services/data/vX/c' => OpenStruct.new('d' => 'You got me.')
      }
    end
    define_method(:lookup) { |url| responses.fetch(url) }
    define_method(:get) { |url| OpenStruct.new(body: lookup(url)) }
    it 'gets an endpoint' do
      assert_equal services, index
      assert_respond_to index, :a
      assert_respond_to index.a, :b
      assert_respond_to index.a.b, :c
      assert_respond_to index.a.b.c, :d
      assert_equal 'You got me.', index.a.b.c.d
    end
  end
end

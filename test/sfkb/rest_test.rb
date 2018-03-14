require 'test_helper'
require 'sfkb/rest'

describe SFKB::REST do
  let(:klass) { Class.new(Minitest::Mock) { include SFKB::REST } }
  let(:subject) { klass.new }
  let(:response) { |x| OpenStruct.new(body: x) }

  describe 'url' do
    it 'joins paths to params amd substitutes vars' do
      assert_equal '/foo', subject.url('/foo')
      assert_equal '/foo?x=1', subject.url('/foo', x: 1)
      assert_equal '/foo?x=1&y=2', subject.url('/foo', x: 1, y: 2)
    end

    it 'substitutes vars' do
      assert_equal '/foo/1/2', subject.url('/foo/<x>/<y>', x: 1, y: 2)
      assert_equal '/foo/1?y=2', subject.url('/foo/<x>', x: 1, y: 2)
      assert_equal '/foo/1?b=2&b=3&c=4',
                    subject.url('/foo/<a>', a: 1, b: %w(2 3), c: 4)
      assert_raises { subject.url('/foo/<blah>') }
    end
  end

  describe 'index' do
    let(:index) { subject.index }

    before do
      subject.expect(:options, { api_version: 'X' })
      subject.expect(:get, OpenStruct.new(body: { a: '/a' }), ['/services/data/vX'])
    end

    it 'looks up the index for the current api version' do
      index
      subject.verify
    end

    it 'is a whatever was returned, hopefully a hash' do
      assert_equal({ a: '/a' }, index)
    end

    it 'adds endpoints for the url values of the hash' do
      subject.expect(:get, OpenStruct.new(body: { b: '/b', c: '/c' }), ['/a'])
      assert_equal({ b: '/b', c: '/c'}, index.a)
    end

    it 'adds endpoints for the subresource' do
      subject.expect(:get, OpenStruct.new(body: { b: '/b', c: '/c' }), ['/a'])
      subject.expect(:get, OpenStruct.new(body: { d: '/d', e: '/e' }), ['/b'])
      subject.expect(:get, OpenStruct.new(body: { f: '/f', g: '/g' }), ['/c'])
      assert_equal '/d', index.a.b.d
      assert_equal '/e', index.a.b.e
      assert_equal '/f', index.a.c.f
      assert_equal '/g', index.a.c.g
    end
  end
end

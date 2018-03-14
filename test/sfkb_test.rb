require 'test_helper'
require 'sfkb'

describe SFKB do
  let(:sfkb) { SFKB.new }

  it 'constructs a client' do
    assert_instance_of SFKB::Client, SFKB.new
  end

  it 'can list articles' do
    assert_respond_to sfkb.articles, :each
  end

  describe 'an article' do
  end
end

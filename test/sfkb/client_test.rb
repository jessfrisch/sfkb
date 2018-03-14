require 'test_helper'
require 'sfkb'

describe SFKB::Client do
  let(:client) { SFKB::Client.new }

  it 'is a Restforce of nature' do
    assert SFKB::Client < Restforce::Data::Client
  end

  it 'knows how to REST' do
    assert SFKB::Client < SFKB::REST
  end

  it 'has great Knowledge' do
    assert SFKB::Client < SFKB::Knowledge
  end
end

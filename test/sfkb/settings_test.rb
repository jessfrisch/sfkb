require 'test_helper'
require 'sfkb/settings'

describe SFKB::Settings do
  let(:subject) { klass.new }
  let(:klass) { Class.new(Minitest::Mock) { include SFKB::Settings } }

  let(:index) { Minitest::Mock.new('index') } 
  let(:languages) { %w(zh ja en).map { |l| OpenStruct.new(name: l, active: l != 'ja') } }
  let(:knowledgeManagement) { Minitest::Mock.new('knowledgeManagement') }
  let(:settings) { OpenStruct.new(defaultLanguage: 'en', languages: languages) }
    
  before do
    subject.expect :index, index
    index.expect :knowledgeManagement, knowledgeManagement
    knowledgeManagement.expect :settings, settings
  end

  it 'knows its default language' do
    assert_equal 'en', subject.defaultLanguage
  end

  it 'knows its languages' do
    assert_equal languages, subject.languages
  end

  it 'knows its active languages' do
    assert_equal %w(zh en), subject.active_languages
  end
end

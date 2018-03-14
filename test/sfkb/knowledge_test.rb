require 'test_helper'
require 'hipsterhash'
require 'sfkb/knowledge'

describe SFKB::Knowledge do
  let(:subject) { klass.new }

  let(:klass) do
    Class.new(Minitest::Mock) do
      include SFKB::Knowledge
      define_method(:index) do
        HipsterHash.new.tap do |hh|
          hh[:knowledgeManagement] = {
            articles: {
              article: '/articles/<ArticleID>'
            }
          }
        end
      end
    end
  end

  let(:ids) { %w(1 2 3).map { |id| Struct.new(:Id).new(id) } }

  describe 'article_ids' do
    it 'gets a list of article IDs' do
      subject.expect(:query, ids, [/KnowledgeArticle/])
      assert_equal %w(1 2 3), subject.article_ids
    end
  end

  describe 'articles' do
    it 'gets all articles based on the article_ids' do
      subject.expect(:query, ids, [/KnowledgeArticle/])
      subject.expect(:get, Struct.new(:body).new('a'), ['/articles/1'])
      subject.expect(:get, Struct.new(:body).new('b'), ['/articles/2'])
      subject.expect(:get, Struct.new(:body).new('c'), ['/articles/3'])
      assert_equal %w(a b c), subject.articles.to_a
    end
  end

  describe 'article' do
    it 'gets a particular article' do
      subject.expect(:get, Struct.new(:body).new('a'), ['/articles/1'])
      assert_equal 'a', subject.article(1)
    end
  end
end

require 'sfkb/rest'
require 'sfkb/settings'
require 'sfkb/decoration'

module SFKB
  module Knowledge
    include REST
    include Settings
    include Decoration

    # Queries for all (undeleted) article IDs, returning an array.
    def article_ids
      query('SELECT Id FROM KnowledgeArticle').map(&:Id)
    end

    # Enumerates articles
    def articles
      Enumerator.new do |y|
        article_ids.each do |id|
          y << article(id)
        end
      end
    end

    # Gets an article by ID
    def article(id)
      url = index.knowledgeManagement.articles.article
      url = url(url, ArticleID: id)
      decorate(get(url).body) { |o| autodefine(o) }
    end
  end
end

require 'restforce/data/client'
require 'sfkb/rest'
require 'sfkb/knowledge'

# An SFKB::Client is an object with a connection to salesforce that can lookup
# KnowledgeArticles and KnowledgeArticleVersions using the Salesforce REST
# API.
class SFKB::Client < Restforce::Data::Client
  include SFKB::REST
  include SFKB::Knowledge
end

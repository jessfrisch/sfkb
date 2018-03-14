require 'restforce'
require 'dotenv/load'

# A helper library for using the Salesforce Knowledge base in Ruby.
module SFKB
  autoload :Knowledge, 'sfkb/knowledge'
  autoload :Client, 'sfkb/client'
  autoload :REST, 'sfkb/rest'

  def self.new(*args)
    Client.new(*args)
  end
end

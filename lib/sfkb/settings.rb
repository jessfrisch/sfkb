module SFKB
  # Methods for getting Salesforce Knowledge settings. Mix it into something
  # with an index.
  module Settings
    # Tells the default language
    def defaultLanguage
      settings.defaultLanguage
    end

    # The list of languages
    def languages
      settings.languages
    end

    def active_languages
      settings.languages.select(&:active).map(&:name)
    end

    def settings
      index.knowledgeManagement.settings
    end
  end
end

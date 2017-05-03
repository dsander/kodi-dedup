module KodiDedup
  class Config
    attr_reader :perform, :replace, :with, :url

    def initialize(options)
      @perform = options['perform']
      if options['replace']
        @replace = options['replace'].keys.first
        @with    = options['replace'].values.first
      end
      @url     = options['url']
    end
  end
end

module KodiDedup
  class Config
    attr_reader :perform, :replace, :with, :url, :mediainfo

    def initialize(options)
      @perform = options['perform']
      if options['replace']
        @replace = options['replace'].keys.first
        @with    = options['replace'].values.first
      end
      @url     = options['url']
      @mediainfo = options[:mediainfo] || KodiDedup::Mediainfo
    end
  end
end

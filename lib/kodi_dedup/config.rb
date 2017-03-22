module KodiDedup
  class Config
    attr_reader :perform, :replace, :with

    def initialize(options)
      @perform = options['perform']
      @replace = options['replace']
      @with    = options['with']
    end
  end
end

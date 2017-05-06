module KodiDedup
  class Show
    def initialize(data)
      @data = data
    end

    def episodes
      @episodes ||= KodiDedup.episodes(tvshowid)
    end

    def method_missing(method, *args)
      return @data[method.to_s] if @data[method.to_s]
      super(method, args)
    end
  end
end

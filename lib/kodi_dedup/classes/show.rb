module KodiDedup
  class Show
    def initialize(data)
      @data = data
    end

    def episodes
      @episodes ||= KodiDedup.episodes(tvshowid)
    end

    def method_missing(method, *args)
      @data[method.to_s].presence || super(method, args)
    end

    def respond_to_missing?(method, *)
      @data[method.to_s].presence || super
    end
  end
end

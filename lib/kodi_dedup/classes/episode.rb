module KodiDedup
  class Episode
    def initialize(data)
      @data = data
      @data['file'] = @data['file'].gsub(KodiDedup.config.replace, KodiDedup.config.with)
    end

    def method_missing(method, *args)
      return @data[method.to_s] if @data[method.to_s]
      super(method, args)
    end

    def mark_as_played!
      KodiDedup.client.video_library.SetEpisodeDetails(episodeid: episodeid, playcount: 1, lastplayed: Time.now)
    end

    def exists?
      File.exist?(file)
    end

    def self.wrap(e)
      if e.is_a?(Episode)
        e
      else
        Episode.new(e)
      end
    end
  end
end

module KodiDedup
  class Shows < Array
    def initialize(series)
      super(series.map { |s| Show.new(s)})
    end
  end

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

  class Episodes < Array
    def initialize(episodes)
      super(episodes.map { |e| Episode.wrap(e) }.select { |e| e.exists? })
    end

    def grouped
      group_by { |e| [e.season, e.episode] }.values.map { |episodes| Episodes.new(episodes) }
    end

    def unplayed
      select { |e| e.playcount == 0 }
    end

    def total_playcount
      sum { |e| e.playcount }
    end
  end

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
      File.exists?(file)
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

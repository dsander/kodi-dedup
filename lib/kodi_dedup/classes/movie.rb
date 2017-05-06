module KodiDedup
  class Movie
    def initialize(data)
      @data = data
      @data['file'] = @data['file'].gsub(KodiDedup.config.replace, KodiDedup.config.with)
    end

    def method_missing(method, *args)
      return @data[method.to_s] if @data[method.to_s]
      super(method, args)
    end

    def mark_as_played!
      KodiDedup.client.video_library.SetMovieDetails(movieid: movieid, playcount: 1, lastplayed: Time.now)
    end

    def exists?
      File.exist?(file)
    end

    def self.wrap(e)
      if e.is_a?(Movie)
        e
      else
        Movie.new(e)
      end
    end
  end
end

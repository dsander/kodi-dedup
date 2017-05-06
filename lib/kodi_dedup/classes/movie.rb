module KodiDedup
  class Movie < Medium
    def mark_as_played!
      KodiDedup.client.video_library.SetMovieDetails(movieid: movieid, playcount: 1, lastplayed: Time.now)
    end
  end
end

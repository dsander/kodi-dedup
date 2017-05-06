module KodiDedup
  class Episode < Medium
    def mark_as_played!
      KodiDedup.client.video_library.SetEpisodeDetails(episodeid: episodeid, playcount: 1, lastplayed: Time.now)
    end
  end
end

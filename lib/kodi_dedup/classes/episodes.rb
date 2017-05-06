module KodiDedup
  class Episodes < Media
    def initialize(episodes)
      super(media: episodes, singular_class: Episode, group_by_proc: -> (e) { [e.season, e.episode] })
    end
  end
end

module KodiDedup
  class Movies < Media
    def initialize(movies)
      super(media: movies, singular_class: Movie, group_by_proc: -> (m) { m.label })
    end
  end
end

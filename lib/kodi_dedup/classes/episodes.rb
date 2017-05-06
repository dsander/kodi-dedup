module KodiDedup
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
end

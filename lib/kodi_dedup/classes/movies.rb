module KodiDedup
  class Movies < Array
    def initialize(movies)
      super(movies.map { |m| Movie.wrap(m)}.select { |m| m.exists? })
    end

    def grouped
      group_by { |m| m.label }.values.select { |movies| movies.length > 1 }.map { |movies| Movies.new(movies) }
    end

    def unplayed
      select { |e| e.playcount == 0 }
    end

    def total_playcount
      sum { |e| e.playcount }
    end
  end
end

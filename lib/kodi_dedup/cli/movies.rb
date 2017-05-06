module KodiDedup
  class Cli
    class Movies
      include Base

      def perform
        shell.say 'Dry running, call with --perform to change perform the deduplication', :green unless KodiDedup.config.perform

        shell.say 'Locating duplicate movies ...'
        KodiDedup.movies.grouped.each do |movies|
          movie = movies.first
          dedup = Deduplicator.new(movies)

          dedup.preable do
            shell.say movie.label.to_s, :yellow
          end

          deduplicate!(dedup)
        end
      end
    end
  end
end

module KodiDedup
  class Cli
    class Movies
      def perform
        shell.say 'Dry running, call with --perform to change perform the deduplication', :green unless KodiDedup.config.perform

        shell.say 'Locating duplicate movies ...'
        KodiDedup.movies.grouped.each do |movies|
          movie = movies.first
          dedup = Deduplicator.new(movies)

          dedup.preable do
            shell.say "#{movie.label}", :yellow
          end

          dedup.playcounts do |movie|
            movie.mark_as_played! if KodiDedup.config.perform
            shell.say "  ✓ marked all movies as played", :green
          end

          dedup.entries do |movies|
            shell.say "  found #{movies.length} duplicate file(s):"
            movies.each_with_index do |m, i|
              shell.say "  #{i} #{m.basename} (#{m})"
            end
            next unless KodiDedup.config.perform

            keep = shell.ask('Which file do you want to keep?', default: '0', limited_to: movies.length.times.map(&:to_s)).to_i
            movies.each_with_index do |m, i|
              next if i == keep
              FileUtils.rm(m.filename)
            end
          end
        end
      end

      def shell
        KodiDedup.shell
      end
    end
  end
end

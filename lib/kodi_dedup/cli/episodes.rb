module KodiDedup
  class Cli
    class Episodes
      def perform
        shell.say 'Dry running, call with --perform to change perform the deduplication', :green unless KodiDedup.config.perform

        shell.say 'Locating duplicate episodes ...'

        grouped_episodes_by_show do |show, episodes|
          dedup = Deduplicator.new(episodes)

          dedup.preable do
            shell.say "#{show.label} #{episodes.first.label}", :yellow
          end

          dedup.playcounts do |episode|
            episode.mark_as_played! if KodiDedup.config.perform
            shell.say "  ✓ marked all episodes as played", :green
          end

          dedup.entries do |episodes|
            shell.say "  found #{episodes.length} duplicate file(s):"
            episodes.each_with_index do |m, i|
              shell.say "  #{i} #{m}"
            end
            next unless KodiDedup.config.perform

            keep = shell.ask('Which file do you want to keep?', default: '0', limited_to: episodes.length.times.map(&:to_s)).to_i
            episodes.each_with_index do |m, i|
              next if i == keep
              FileUtils.rm(m.filename)
            end
          end
        end
      end

      def grouped_episodes_by_show
        KodiDedup.shows.each do |show|
          next if show.episodes.empty?

          show.episodes.grouped.each do |episodes|
            next if episodes.length == 1
            yield show, episodes
          end
        end
      end

      def shell
        KodiDedup.shell
      end
    end
  end
end

module KodiDedup
  class Cli
    class Episodes
      include Base

      def perform
        shell.say 'Dry running, call with --perform to change perform the deduplication', :green unless KodiDedup.config.perform

        shell.say 'Locating duplicate episodes ...'

        grouped_episodes_by_show do |show, episodes|
          dedup = Deduplicator.new(episodes)

          dedup.preable do
            shell.say "#{show.label} #{episodes.first.label}", :yellow
          end

          deduplicate!(dedup)
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
    end
  end
end

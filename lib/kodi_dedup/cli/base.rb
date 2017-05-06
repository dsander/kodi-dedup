module KodiDedup
  class Cli
    module Base
      def deduplicate!(dedup)
        dedup.playcounts do |entry|
          entry.mark_as_played! if KodiDedup.config.perform
          shell.say "  ✓ marked all movies as played", :green
        end

        dedup.entries do |entries|
          shell.say "  found #{entries.length} duplicate file(s):"
          entries.each_with_index do |m, i|
            shell.say "  #{i} #{m}"
          end
          next unless KodiDedup.config.perform

          keep = shell.ask('Which file do you want to keep?', default: '0', limited_to: entries.length.times.map(&:to_s)).to_i
          entries.each_with_index do |m, i|
            next if i == keep
            FileUtils.rm(m.filename)
          end
        end
      end

      def shell
        KodiDedup.shell
      end
    end
  end
end

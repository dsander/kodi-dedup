module KodiDedup
  class Deduplicator
    attr_reader :subject

    def initialize(subject)
      @subject = subject
    end

    def preable
      yield if deduplication_required?
    end

    def deduplication_required?
      deduplicate_playcounts? || deduplicate_entries?
    end

    def deduplicate_playcounts?
      subject.total_playcount > 0
    end

    def deduplicate_entries?
      !subject.empty?
    end

    def playcounts
      return unless deduplicate_playcounts?
      subject.unplayed.each do |object|
        yield object
      end
    end

    def entries
      return unless deduplicate_entries?
      yield(subject.map do |e|
        KodiDedup::MediaFile.new e.file
      end.sort)
    end
  end
end

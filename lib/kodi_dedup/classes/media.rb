module KodiDedup
  class Media < Array
    attr_reader :singular_class, :group_by_proc

    def initialize(media:, singular_class:, group_by_proc: )
      @singular_class = singular_class
      @group_by_proc = group_by_proc
      super(media.map { |m| singular_class.wrap(m) }.select { |m| m.exists? })
    end

    def grouped
      group_by(&@group_by_proc).values.select { |media| media.length > 1 }.map { |media| self.class.new(media) }
    end

    def unplayed
      select { |e| e.playcount == 0 }
    end

    def total_playcount
      sum { |e| e.playcount }
    end
  end
end

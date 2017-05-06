module KodiDedup
  class Shows < Array
    def initialize(series)
      super(series.map { |s| Show.new(s)})
    end
  end
end

module KodiDedup
  class Medium
    def initialize(data)
      @data = data
      @data['file'] = @data['file'].gsub(KodiDedup.config.replace, KodiDedup.config.with)
    end

    def method_missing(method, *args)
      return @data[method.to_s] if @data[method.to_s]
      super(method, args)
    end

    def mark_as_played!
      raise NotImplementedError
    end

    def exists?
      File.exist?(file)
    end

    def self.wrap(e)
      if e.is_a?(self)
        e
      else
        self.new(e)
      end
    end
  end
end

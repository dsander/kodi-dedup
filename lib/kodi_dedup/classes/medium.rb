module KodiDedup
  class Medium
    def initialize(data)
      @data = data
      @data['file'] = @data['file'].gsub(KodiDedup.config.replace, KodiDedup.config.with) if KodiDedup.config.replace
    end

    def method_missing(method, *args)
      @data[method.to_s] || super(method, args)
    end

    def respond_to_missing?(method, *)
      @data[method.to_s].presence || super
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
        new(e)
      end
    end
  end
end

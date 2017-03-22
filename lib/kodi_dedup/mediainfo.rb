module KodiDedup
  class Mediainfo
    attr_reader :width, :height, :format, :filename

    def initialize(filename:)
      @filename = filename
      @info = ::Mediainfo.new(filename)
    end

    def width
      @info.video.width
    end

    def height
      @info.video.height
    end

    def format
      @info.video.format
    end

    def size
      @size ||= File.stat(filename).size
    end
  end
end

module KodiDedup
  class MediaFile
    include Comparable
    attr_reader :filename, :mediainfo

    FORMATS = ['unknown', 'MPEG-4 Visual', 'AVC', 'HEVC']

    def initialize(filename)
      @filename  = filename
      @mediainfo = KodiDedup.config.mediainfo.new(filename: filename)
    end

    def <=>(other)
      if other.resolution != resolution
        other.resolution <=> resolution
      elsif other.format_index != format_index
        other.format_index <=> format_index
      elsif other.size != size
        size <=> other.size
      else
        0
      end
    end

    def ==(other)
      width == other.width && height == other.height && format == other.format && size == other.size
    end

    def size
      (mediainfo.size / (1024*1024.0)).to_i
    end

    def resolution
      width * height
    end

    def width
      mediainfo.width
    rescue ::Mediainfo::StreamProxy::NoStreamsForProxyError
      0
    end

    def height
      mediainfo.height
    rescue ::Mediainfo::StreamProxy::NoStreamsForProxyError
      0
    end

    def format
      mediainfo.format
    rescue ::Mediainfo::StreamProxy::NoStreamsForProxyError
      'unknown'
    end

    def basename
      File.basename(filename)
    end

    def format_index
      FORMATS.index(format)
    end

    def to_s
      "#{basename} (#{format}@#{width}x#{height} #{size}MB)"
    end
  end
end

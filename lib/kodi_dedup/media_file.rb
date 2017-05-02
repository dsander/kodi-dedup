module KodiDedup
  class MediaFile
    include Comparable
    extend Forwardable
    def_delegators :@mediainfo, :width, :height, :format
    attr_reader :filename

    FORMATS = ['MPEG-4 Visual', 'AVC', 'HEVC']

    def initialize(filename, mediainfo: Mediainfo)
      @filename  = filename
      @mediainfo = mediainfo.new(filename: filename)
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
      (@mediainfo.size / (1024*1024.0)).to_i
    end

    def resolution
      width * height
    end

    def basename
      File.basename(filename)
    end

    def format_index
      FORMATS.index(format)
    end

    def inspect
      "#<KodiDedup::MediaFile:#{__id__} @resolution='#{width}x#{height}', @format='#{format}' @size=#{size}>"
    end
  end
end

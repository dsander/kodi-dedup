require "spec_helper"

describe KodiDedup::MediaFile do
  class FullHd265
    def initialize(filename); end
    def width; 1920 end
    def height; 1080 end
    def format; 'HEVC' end
    def size; 400 * 1024 * 1024 end
  end

  class FullHd264 < FullHd265
    def format; 'AVC' end
    def size; 1000 * 1024 * 1024 end
  end

  class Hd264 < FullHd264
    def width; 1280 end
    def height; 720 end
  end

  class Hd265 < Hd264
    def format; 'HEVC' end
  end

  class Hd265Small < Hd265
    def size; 500 * 1024 * 1024 end
  end

  let(:fullhd265)  { KodiDedup::MediaFile.new('text.mkv', mediainfo: FullHd265) }
  let(:fullhd264)  { KodiDedup::MediaFile.new('text.mkv', mediainfo: FullHd264) }
  let(:hd264)      { KodiDedup::MediaFile.new('text.mkv', mediainfo: Hd264) }
  let(:hd265)      { KodiDedup::MediaFile.new('text.mkv', mediainfo: Hd265) }
  let(:hd265small) { KodiDedup::MediaFile.new('text.mkv', mediainfo: Hd265Small) }

  context 'sorting' do

    it 'prefers fullhd over hd' do
      expect([hd265, hd264, fullhd264].sort).to eq([fullhd264, hd265, hd264])
    end

    it 'prefers HEVC over AVC' do
      expect([hd265, fullhd264, hd264, fullhd265].sort).to eq([fullhd265, fullhd264, hd265, hd264])
    end

    it 'prefers smaller files if everything else is identical' do
      expect([hd265, hd265small].sort).to eq([hd265small, hd265])
    end
  end
end

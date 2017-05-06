require "spec_helper"

describe KodiDedup::MediaFile do
  let(:fullhd265)  { KodiDedup.config!(mediainfo: FullHd265); KodiDedup::MediaFile.new('text.mkv') }
  let(:fullhd264)  { KodiDedup.config!(mediainfo: FullHd264); KodiDedup::MediaFile.new('text.mkv') }
  let(:hd264)      { KodiDedup.config!(mediainfo: Hd264); KodiDedup::MediaFile.new('text.mkv') }
  let(:hd265)      { KodiDedup.config!(mediainfo: Hd265); KodiDedup::MediaFile.new('text.mkv') }
  let(:hd265small) { KodiDedup.config!(mediainfo: Hd265Small); KodiDedup::MediaFile.new('text.mkv') }

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

    it 'checks for equality correctly' do
      expect(hd265).to eq(hd265)
      expect(hd265).not_to eq(hd264)
    end
  end

  context 'catching Mediainfo exceptions' do
    let(:mf) { KodiDedup.config!(mediainfo: RaisingMediainfo); KodiDedup::MediaFile.new('text.mkv') }

    it 'returns 0 for the width' do
      expect(mf.width).to eq(0)
    end

    it 'returns 0 for the height' do
      expect(mf.height).to eq(0)
    end

    it 'returns 0 for the resolution' do
      expect(mf.resolution).to eq(0)
    end

    it 'returns unknown for the format' do
      expect(mf.format).to eq('unknown')
    end

  end
end

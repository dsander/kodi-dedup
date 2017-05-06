require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "kodi_dedup"
require 'webmock/rspec'

RSpec.configure do |c|
  c.filter_run focus: true
  c.run_all_when_everything_filtered = true
end

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

class RaisingMediainfo < Hd265
  def width; raise ::Mediainfo::StreamProxy::NoStreamsForProxyError end
  def height; width end
  def format; width end
end

require 'fileutils'
require 'kodi'
require 'mediainfo'
require 'thor'

require 'kodi_dedup/classes'
require 'kodi_dedup/cli'
require 'kodi_dedup/cli/episodes'
require 'kodi_dedup/cli/movies'
require 'kodi_dedup/config'
require 'kodi_dedup/deduplicator'
require "kodi_dedup/media_file"
require "kodi_dedup/mediainfo"
require "kodi_dedup/version"

module KodiDedup
  def self.client
    @client ||= Kodi::Client.new(config.url)
  end

  def self.shows
    Shows.new(client.video_library.GetTVShows['tvshows'])
  end

  def self.episodes(show_id)
    episodes = KodiDedup.client.video_library.GetEpisodes(tvshowid: show_id, properties: [:season, :episode, :file, :lastplayed, :playcount])['episodes']
    return [] unless episodes
    Episodes.new(episodes)
  end

  def self.movies
    Movies.new(KodiDedup.client.video_library.GetMovies(properties: [:file, :title, :playcount])['movies'])
  end

  def self.config!(options)
    @config = Config.new(options)
  end

  def self.config
    @config
  end

  def self.shell
    @shell ||= Thor::Shell::Color.new
  end
end

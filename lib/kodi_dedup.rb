require 'fileutils'
require 'kodi'
require 'mediainfo'
require 'thor'

require 'kodi_dedup/classes/media'
require 'kodi_dedup/classes/medium'
require 'kodi_dedup/classes/episode'
require 'kodi_dedup/classes/episodes'
require 'kodi_dedup/classes/movie'
require 'kodi_dedup/classes/movies'
require 'kodi_dedup/classes/show'
require 'kodi_dedup/classes/shows'
require 'kodi_dedup/cli'
require 'kodi_dedup/cli/base'
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
    episodes = KodiDedup.client.video_library.GetEpisodes(tvshowid: show_id, properties: %i[season episode file lastplayed playcount])['episodes']
    return [] unless episodes
    Episodes.new(episodes)
  end

  def self.movies
    Movies.new(KodiDedup.client.video_library.GetMovies(properties: %i[file title playcount])['movies'])
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

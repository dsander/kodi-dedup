module KodiDedup
  class Cli < Thor
    desc "episodes", "Clean up duplicate show episodes in your Kodi library"
    method_option :url, type: :string, required: true, desc: "URI string to the Kodi JSON API endpoint (http://kodi:kodi@localhost:8080/jsonrpc)"
    method_option :perform, type: :boolean, default: false, desc: "Actually perform the actions"
    method_option :replace, type: :hash, desc: "Replace 'key' with 'value' in the file paths returned by Kodi"
    def episodes
      KodiDedup.config!(options)
      KodiDedup::Cli::Episodes.new.perform
    end

    desc "movies", "Clean up duplicate movies in your Kodi library"
    method_option :url, type: :string, required: true, desc: "URI string to the Kodi JSON API endpoint (http://kodi:kodi@localhost:8080/jsonrpc)"
    method_option :perform, type: :boolean, default: false, desc: "Actually perform the actions"
    method_option :replace, type: :hash, desc: "Replace 'key' with 'value' in the file paths returned by Kodi"
    def movies
      KodiDedup.config!(options)
      KodiDedup::Cli::Movies.new.perform
    end
  end
end

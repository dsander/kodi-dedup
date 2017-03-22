module KodiDedup
  class Cli < Thor
    desc "episodes", "Clean up duplicate show episodes in your Kodi library"
    method_options perform: :boolean, replace: :string, with: :string
    def episodes
      KodiDedup.config!(options)
      KodiDedup::Cli::Episodes.new
    end
  end
end

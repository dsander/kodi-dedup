require "spec_helper"

describe KodiDedup::Cli::Episodes do
  def stub_requests(file)
    stub_request(:post, "http://localhost/").
      with(body: "{\"method\":\"JSONRPC.Introspect\",\"params\":{},\"jsonrpc\":\"2.0\",\"id\":\"1\"}").
      to_return(status: 200, body: File.read('spec/data/rpc-introspect.json'))
    stub_request(:post, "http://localhost/").
      with(body: "{\"method\":\"VideoLibrary.GetTVShows\",\"params\":{},\"jsonrpc\":\"2.0\",\"id\":\"1\"}").
      to_return(status: 200, body: File.read('spec/data/shows.json'))
    stub_request(:post, "http://localhost/").
      with(body: "{\"method\":\"VideoLibrary.GetEpisodes\",\"params\":{\"tvshowid\":141,\"properties\":[\"season\",\"episode\",\"file\",\"lastplayed\",\"playcount\"]},\"jsonrpc\":\"2.0\",\"id\":\"1\"}").
      to_return(status: 200, body: File.read("spec/data/#{file}.json"))
  end

  it 'dry runs the deduplication' do
    stub_requests('episodes')
    allow(File).to receive(:exist?).and_return(true)
    KodiDedup.config!('perform' => false, 'url' => 'http://localhost', 'replace' => {'' => ''}, mediainfo: FullHd265)
    cli = KodiDedup::Cli::Episodes.new
    allow(cli).to receive_message_chain(:shell, :say).with(/Dry running/, any_args)
    expect(cli).to receive_message_chain(:shell, :say).with(/Locating duplicate/, any_args)
    expect(cli).to receive_message_chain(:shell, :say).with(/The Big Bang Theory/, any_args)
    expect(cli).to receive_message_chain(:shell, :say).with(/as played/, any_args)
    expect(cli).to receive_message_chain(:shell, :say).with(/found 2 duplicate file/, any_args)
    expect(cli).to receive_message_chain(:shell, :say).with(/The.Big.Bang.Theory.s06e19.The.Closet.Reconfiguration.mkv \(HEVC@1920x1080 400MB\)/)
    expect(cli).to receive_message_chain(:shell, :say).with(/The.Big.Bang.Theory.s06e19.The.Closet.Reconfiguration-2.mkv \(HEVC@1920x1080 400MB\)/)
    cli.perform
  end

  it 'performs the deduplication' do
    stub_requests('episodes')
    stub_request(:post, "http://localhost/").
      with(body: /VideoLibrary.SetEpisodeDetails/).
      to_return(status: 200, body: "{}", headers: {})
    allow(File).to receive(:exist?).and_return(true)
    KodiDedup.config!('perform' => true, 'url' => 'http://localhost', 'replace' => {'' => ''}, mediainfo: FullHd265)
    cli = KodiDedup::Cli::Episodes.new
    allow(cli).to receive_message_chain(:shell, :say).with(any_args)
    expect(cli).to receive_message_chain(:shell, :ask).with(any_args).and_return('1')
    expect(FileUtils).to receive(:rm).with('/media/Series/The Big Bang Theory/Season 06/The.Big.Bang.Theory.s06e19.The.Closet.Reconfiguration.mkv')
    cli.perform
  end

  it 'shell returns a thor collor shell instance' do
    expect(KodiDedup::Cli::Episodes.new.shell).to be_a(Thor::Shell::Color)
  end
end

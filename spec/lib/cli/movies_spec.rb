require "spec_helper"

describe KodiDedup::Cli::Movies do
  def stub_requests(file)
    stub_request(:post, "http://localhost/").
      with(body: "{\"method\":\"JSONRPC.Introspect\",\"params\":{},\"jsonrpc\":\"2.0\",\"id\":\"1\"}").
      to_return(status: 200, body: File.read('spec/data/rpc-introspect.json'))
    stub_request(:post, "http://localhost/").
      with(body: "{\"method\":\"VideoLibrary.GetMovies\",\"params\":{\"properties\":[\"file\",\"title\",\"playcount\"]},\"jsonrpc\":\"2.0\",\"id\":\"1\"}").
      to_return(status: 200, body: File.read("spec/data/#{file}.json"))

  end
  it 'dry runs the deduplication' do
    stub_requests('movies')
    allow(File).to receive(:exist?).and_return(true)
    KodiDedup.config!('perform' => false, 'url' => 'http://localhost', 'replace' => {'' => ''}, mediainfo: FullHd265)
    cli = KodiDedup::Cli::Movies.new
    allow(cli).to receive_message_chain(:shell, :say).with(/Dry running/, any_args)
    expect(cli).to receive_message_chain(:shell, :say).with(/Locating duplicate/, any_args)
    expect(cli).to receive_message_chain(:shell, :say).with('Elephants Dream', any_args)
    expect(cli).to receive_message_chain(:shell, :say).with(/as played/, any_args)
    expect(cli).to receive_message_chain(:shell, :say).with(/found 2 duplicate file/, any_args)
    expect(cli).to receive_message_chain(:shell, :say).with(/Elephants Dream.mkv/)
    expect(cli).to receive_message_chain(:shell, :say).with(/Elephants Dream.avi/)
    cli.perform
  end

  it 'performs the deduplication' do
    stub_requests('movies')
    stub_request(:post, "http://localhost/").
      with(body: /VideoLibrary.SetMovieDetails/).
      to_return(status: 200, body: "{}", headers: {})
    allow(File).to receive(:exist?).and_return(true)
    KodiDedup.config!('perform' => true, 'url' => 'http://localhost', 'replace' => {'' => ''}, mediainfo: FullHd265)
    cli = KodiDedup::Cli::Movies.new
    allow(cli).to receive_message_chain(:shell, :say).with(any_args)
    expect(cli).to receive_message_chain(:shell, :ask).with(any_args).and_return('1')
    expect(FileUtils).to receive(:rm).with('/media/Movies/Elephants Dream/Elephants Dream.mkv')
    cli.perform
  end

  it 'shell returns a thor collor shell instance' do
    expect(KodiDedup::Cli::Movies.new.shell).to be_a(Thor::Shell::Color)
  end
end

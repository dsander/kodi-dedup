# kodi-dedup

`kodi-dedup` finds duplicate show episodes and movies in your Kodi library. It unifies the playcount and offers to delete the duplicates only keeping the file with the best quality.

## Requirements

* Ruby 2.2+

## Installation

```
gem install kodi-dedup
```

## Usage

```
$ kodi-dedup
Commands:
  kodi-dedup episodes --url=URL  # Clean up duplicate show episodes in your Kodi library
  kodi-dedup help [COMMAND]      # Describe available commands or one specific command
  kodi-dedup movies --url=URL    # Clean up duplicate movies in your Kodi library
```

```
$ kodi-dedup help episodes
Usage:
  kodi-dedup episodes --url=URL

Options:
  --url=URL                    # URI string to the Kodi JSON API endpoint (http://kodi:kodi@localhost:8080/jsonrpc)
  [--perform], [--no-perform]  # Actually perform the actions
  [--replace=key:value]        # Replace 'key' with 'value' in the file paths returned by Kodi
```

```
$kodi-dedup help movies
Usage:
  kodi-dedup movies --url=URL

Options:
  --url=URL                    # URI string to the Kodi JSON API endpoint (http://kodi:kodi@localhost:8080/jsonrpc)
  [--perform], [--no-perform]  # Actually perform the actions
  [--replace=key:value]        # Replace 'key' with 'value' in the file paths returned by Kodi
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dsander/kodi-dedup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


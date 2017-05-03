# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kodi_dedup/version'

Gem::Specification.new do |spec|
  spec.name          = "kodi-dedup"
  spec.version       = KodiDedup::VERSION
  spec.authors       = ["Dominik Sander"]
  spec.email         = ["git@dsander.de"]

  spec.summary       = %q{CLI application to locate and delete duplicate Episodes in Kodi}
  spec.description   = %q{CLI application to locate and delete duplicate Episodes in Kodi}
  spec.homepage      = "https://github.com/dsander/kodi-dedup"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'mediainfo', '~> 0.7'
  spec.add_runtime_dependency 'thor', '~> 0.19'
  spec.add_runtime_dependency 'dsander-kodi', '~> 0.2'
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kodi_dedup/version'

Gem::Specification.new do |spec|
  spec.name          = "kodi-dedup"
  spec.version       = KodiDedup::VERSION
  spec.authors       = ["Dominik Sander"]
  spec.email         = ["git@dsander.de"]

  spec.summary       = 'CLI application to locate and delete duplicate media in Kodi'
  spec.homepage      = "https://github.com/dsander/kodi-dedup"
  spec.license       = "MIT"

  spec.files         = Dir['CHANGELOG.md', 'LICENSE.txt', 'lib/**/*', 'bin/*']
  spec.bindir        = "bin"
  spec.executables   = 'kodi-dedup'
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'mediainfo', '~> 0.7'
  spec.add_runtime_dependency 'thor', '~> 0.19'
  spec.add_runtime_dependency 'dsander-kodi', '~> 0.2'
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", '~> 0.14'
  spec.add_development_dependency 'webmock', '~> 3'
end

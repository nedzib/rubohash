
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubohash/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubohash'
  spec.version       = Rubohash::VERSION
  spec.authors       = ['Mark Holmberg']
  spec.email         = ['mark.holmberg@icentris.com']

  spec.summary       = 'It generates SHA512 Robot Images.'
  spec.description   = 'Ruby adaptation of robohash.org'
  spec.homepage      = 'https://github.com/nedzib/rubohash'
  spec.license       = 'MIT'

  spec.metadata = { 'homepage_uri' => spec.homepage }
  spec.required_ruby_version = '>= 2.7'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'mini_magick', '~> 4.9.4'

  spec.add_development_dependency 'bundler', '~> 2.4'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'yard', '~> 0.9', '>= 0.9.20'
  spec.add_development_dependency 'rubocop', '>= 1.60', '< 2.0'
end

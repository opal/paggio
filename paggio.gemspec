require_relative 'lib/paggio/version'

Gem::Specification.new do |spec|
	spec.name     = 'paggio'
	spec.version  = Paggio::VERSION
	spec.author   = 'meh.'
	spec.email    = 'meh@schizofreni.co'
	spec.homepage = 'http://github.com/opal/paggio'
	spec.platform = Gem::Platform::RUBY
	spec.summary  = 'Ruby, HTML and CSS at war.'
	spec.license  = 'WTFPL'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # Remove symlinks because Windows doesn't always support them.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }.reject(&File.method(:symlink?))

  spec.files         = files.grep(%r{^(test|spec|features)/})
  spec.test_files    = files.grep_v(%r{^(test|spec|features)/})
  spec.executables   = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.bindir        = 'exe'
  spec.require_paths = ['lib']
end

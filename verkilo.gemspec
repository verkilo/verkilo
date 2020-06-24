
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "verkilo/version"

Gem::Specification.new do |spec|
  spec.name          = "verkilo"
  spec.version       = Verkilo::VERSION
  spec.authors       = ["Ben W"]
  spec.email         = ["merovex@gmail.com"]

  spec.summary       = %q{Sustainable publishing with Markdown and Pandoc}
  spec.description   = %q{Sustainable publishing with Markdown and Pandoc}
  spec.homepage      = "https://verkilo.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "https://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/verkilo/verkilo"
    spec.metadata["changelog_uri"] = "https://github.com/verkilo/verkilo/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["verkilo"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 12.3.3", '>= 12.3.3'
  spec.add_dependency "thor", '~> 0'
end

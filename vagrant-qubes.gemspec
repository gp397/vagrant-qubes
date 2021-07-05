# require_relative 'lib/vagrant-qubes/version'
require File.expand_path('../lib/vagrant-qubes/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "vagrant-qubes"
  spec.version       = VagrantPlugins::Qubes::VERSION
  spec.date          = '2021-06-30'
  spec.authors       = ["Gary Pentland"]
  spec.email         = [""]

  spec.summary       = "Vagrant Qubes provider plugin"
  spec.description   = "A plugin for vagrant to provision machines within a qubes environment"
  spec.homepage      = "https://google.co.uk"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.add_runtime_dependency 'log4r', '~> 1.1'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

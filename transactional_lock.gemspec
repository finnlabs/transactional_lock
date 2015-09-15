# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transactional_lock/version'

Gem::Specification.new do |spec|
  spec.name          = "transactional_lock"
  spec.version       = TransactionalLock::VERSION
  spec.authors       = ["Jan Sandbrink"]
  spec.email         = ["j.sandbrink@finn.de"]

  spec.summary       = %q{Adds advisory locks that are automatically released at the end of a transaction.}
  spec.homepage      = 'https://github.com/finnlabs/transactional_lock'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 4.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "sqlite3"
end

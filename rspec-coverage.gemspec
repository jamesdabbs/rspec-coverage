# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/coverage/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-coverage"
  spec.version       = RSpec::Coverage::VERSION
  spec.authors       = ["James Dabbs"]
  spec.email         = ["jamesdabbs@gmail.com"]

  spec.summary       = %q{Filter test results to include only the system under test}
  spec.description   = %q{Filter test results to include only the system under test. A port of minitest-coverage}
  spec.homepage      = "https://github.com/jamesdabbs/rspec-coverage"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec"
  spec.add_dependency "simplecov"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

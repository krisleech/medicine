# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'medicine/version'

Gem::Specification.new do |spec|
  spec.name          = "medicine"
  spec.version       = Medicine::VERSION
  spec.authors       = ["Kris Leech"]
  spec.email         = ["kris.leech@gmail.com"]
  spec.summary       = "Simple Dependency Injection for Ruby"
  spec.description   = "Simple Dependency Injection for Ruby. Find yourself passing dependencies in to the initalizer? Medicine makes this declarative."
  spec.homepage      = "https://github.com/krisleech/medicine"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end

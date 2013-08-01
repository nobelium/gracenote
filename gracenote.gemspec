# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gracenote/version'

Gem::Specification.new do |spec|
  spec.name          = "gracenote"
  spec.version       = "0.0.3"
  spec.authors       = ["nobelium"]
  spec.email         = ["me@vignesh.info"]
  spec.description   = "Gracenote web api gem"
  spec.summary       = "This gem is a wrapper for the gracenote web api"
  spec.homepage      = "http://rubygems.org/gems/gracenote"
  spec.license       = "MIT"

  spec.files         = ["lib/gracenote.rb", "lib/gracenote/HTTP.rb"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "curb"
  spec.add_dependency "ox"
  
end

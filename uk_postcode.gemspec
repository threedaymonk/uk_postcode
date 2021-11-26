$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "uk_postcode/version"

Gem::Specification.new do |s|
  s.name         = "uk_postcode"
  s.version      = UKPostcode::VERSION
  s.summary      = "UK postcode parsing and validation"
  s.description  = "Parse, validate, and extract sub-fields from UK postcodes"
  s.author       = "Paul Battley"
  s.email        = "pbattley@gmail.com"
  s.homepage     = "http://github.com/threedaymonk/uk_postcode"
  s.license      = "MIT"
  s.files        = Dir["README.md", "COPYING.txt", "CHANGES", "lib/**/*"]
  s.require_path = "lib"

  s.add_development_dependency "rake", "~> 13"
  s.add_development_dependency "rspec", "~> 3"

  s.required_ruby_version = ">= 1.9.2"
end

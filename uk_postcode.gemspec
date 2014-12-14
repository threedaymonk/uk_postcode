lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'uk_postcode/version'

Gem::Specification.new do |s|
  s.name         = "uk_postcode"
  s.version      = UKPostcode::VERSION
  s.summary      = "UK postcode parsing and validation"
  s.description  = "Parse, validate, and extract sub-fields from UK postcodes"
  s.author       = "Paul Battley"
  s.email        = "pbattley@gmail.com"
  s.homepage     = "http://github.com/threedaymonk/uk_postcode"
  s.license      = "MIT"
  s.has_rdoc     = true
  s.files        = Dir["{Rakefile,README.md,{bin,test,lib}/**/*}"] -
                   ["test/data/**/*"]
  s.executables  = Dir["bin/**"].map { |f| File.basename(f) }
  s.require_path = 'lib'

  s.add_development_dependency "rake", "~> 0"
end

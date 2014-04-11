lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'uk_postcode/version'

Gem::Specification.new do |s|
  s.name         = "uk_postcode"
  s.version      = UKPostcode::VERSION
  s.summary      = "UK postcode parsing and validation"
  s.author       = "Paul Battley"
  s.email        = "pbattley@gmail.com"
  s.homepage     = "http://github.com/threedaymonk/uk_postcode"
  s.has_rdoc     = true
  s.files        = Dir["{Rakefile,README.md,{bin,test,lib}/**/*}"] - ["test/samples/postzon.list"]
  s.executables  = Dir["bin/**"].map { |f| File.basename(f) }
  s.require_path = 'lib'

  s.add_development_dependency "rake"
end

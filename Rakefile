require "rubygems"
require "rake/gempackagetask"
require "rake/testtask"

task :default => [:test]

Rake::TestTask.new("test") do |t|
  t.libs   << "test"
  t.pattern = "test/**/test_*.rb"
  t.verbose = true
end

task :default => :test

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

spec = Gem::Specification.new do |s|
  s.name              = "uk_postcode"
  s.version           = "0.0.1"
  s.summary           = "UK postcode parsing and validation"
  s.author            = "Paul Battley"
  s.email             = "pbattley@gmail.com"

  s.has_rdoc          = true

  s.files             = %w(Rakefile README.md) + Dir.glob("{bin,test,lib}/**/*") - ["test/samples/postzon.list"]
  s.executables       = FileList["bin/**"].map { |f| File.basename(f) }

  s.require_paths     = ["lib"]

  s.add_development_dependency("thoughtbot-shoulda")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc 'Clear out generated packages'
task :clean => [:clobber_package]

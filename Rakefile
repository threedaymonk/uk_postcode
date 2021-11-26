require "rake/clean"
require "rspec/core/rake_task"

ONSPD_URL = "http://parlvid.mysociety.org/os/ONSPD/2020-05.zip"

CLEAN.include FileList["data/**/*", "spec/data/**/*"]

file "data/onspd.zip" do |t|
  tempname = "#{t.name}.tmp"

  mkdir_p File.dirname(t.name)
  sh %{curl -L -o "#{tempname}" "#{ONSPD_URL}"}
  mv tempname, t.name
end

file "data/onspd.csv" => "data/onspd.zip" do |t|
  zipfile, = t.prerequisites
  tempname = "#{t.name}.tmp"

  rm_rf "data/onspd"
  sh %{unzip -d data/onspd "#{zipfile}"}
  sh %{cut -d, -f 1,17 data/onspd/Data/*.csv > "#{tempname}"}
  mv tempname, t.name
end

file "data/postcodes.csv" => "data/onspd.csv" do |t|
  csvfile, = t.prerequisites
  tempname = "#{t.name}.tmp"

  sh %{grep '[A-Z]' "#{csvfile}" | grep -v NPT | sort -uV > "#{tempname}"}
  mv tempname, t.name
end

file "spec/data/postcodes.csv" => "data/postcodes.csv" do |t|
  csvfile, = t.prerequisites

  mkdir_p File.dirname(t.name)
  cp csvfile, t.name
end

file "lib/uk_postcode/country_lookup.rb" => "data/postcodes.csv" do |t|
  csvfile, = t.prerequisites
  tempname = "#{t.name}.tmp"

  sh %{ruby -I./lib tools/generate_country_lookup.rb "#{csvfile}" > "#{tempname}"}
  mv tempname, t.name
end

desc "Run the specs."
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = false
end

namespace :spec do
  desc "Run the specs skipping the (slow) full postcode spec"
  task :quick do
    ENV['SKIP_FULL_TEST'] = 'true'
    task(:spec).invoke
  end
end

task spec: ["spec/data/postcodes.csv", "lib/uk_postcode/country_lookup.rb"]

task :default => [:spec]

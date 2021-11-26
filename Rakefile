require "rake/clean"
require "rspec/core/rake_task"

ONSPD_DATE = "2020-05"

SAMPLE_PERCENT = ENV.fetch("SAMPLE_PERCENT", 1).to_i

CLEAN.include FileList["data/**/*", "spec/data/**/*"]

file "data/#{ONSPD_DATE}.zip" do |t|
  url = "http://parlvid.mysociety.org/os/ONSPD/#{ONSPD_DATE}.zip"
  tempname = "#{t.name}.tmp"

  mkdir_p File.dirname(t.name)
  sh %{curl -L -o "#{tempname}" "#{url}"}
  mv tempname, t.name
end

file "data/onspd.csv" => "data/#{ONSPD_DATE}.zip" do |t|
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

file "spec/data/postcodes_#{SAMPLE_PERCENT}.csv" => "data/postcodes.csv" do |t|
  src, = t.prerequisites
  sample_probability = SAMPLE_PERCENT / 100.0

  File.open(t.name, "w") do |out|
    File.open(src).each_line do |line|
      out << line if rand <= sample_probability
    end
  end
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

task spec: [
  "spec/data/postcodes_#{SAMPLE_PERCENT}.csv",
  "lib/uk_postcode/country_lookup.rb"
]

task :default => [:spec]

require "rspec/core/rake_task"

desc "Run the specs."
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = false
end

namespace :spec do
  desc "Run the specs skipping the (slow) full postcode spec"
  task quick: [:skip_full, :spec]

  task :skip_full do
    ENV['SKIP_FULL_TEST'] = 'true'
  end
end

task :default => [:spec]

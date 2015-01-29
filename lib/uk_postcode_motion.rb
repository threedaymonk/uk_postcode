unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  app.files.unshift(File.join(File.dirname(__FILE__), "uk_postcode.rb"))
end

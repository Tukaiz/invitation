$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "invitation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "invitation"
  s.version     = Invitation::VERSION
  s.authors     = ["Brett Lischalk"]
  s.email       = ["b.lischalk@tukaiz.com"]
  s.homepage    = "https://github.com/Tukaiz/invitation"
  s.summary     = "Add invitation functionality to an app"
  s.description = "Add invitation functionality to an app"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.2"
  s.add_development_dependency 'faker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_dependency "cancan"
  s.add_dependency "cells"

  s.add_development_dependency "sqlite3"
end

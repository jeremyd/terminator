# -*- encoding: utf-8 -*-
require File.expand_path('../lib/terminator/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "terminator"
  s.version     = Terminator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ara T. Howard", "Mikel Lindsaar", "Ben Wiseley", "Sean Geoghegan"]
  s.email       = ["ara.t.howard@gmail.com", "raasdnil@gmail.com", "wiseleyb@gmail.com", "sean@seangeo.me"]
  s.homepage    = "https://github.com/jeremyd/terminator"
  s.date        = Date.today.to_s
  s.summary     = "An external timeout mechanism based on processes and signals."
  s.description =   "An external timeout mechanism based on processes and signals."
  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.add_runtime_dependency "fattr"
  s.add_development_dependency "rspec"
  s.add_development_dependency "bacon"
  s.extensions << "extconf.rb" if File::exists? "extconf.rb"
end


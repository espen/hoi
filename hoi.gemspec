# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hoi', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Espen Antonsen"]
  gem.email         = ["espen@inspired.no"]
  gem.description   = %q{API for Hoiio}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/espen/hoi"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "hoi"
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency(%q<json>, ["> 1.4.0"])
  gem.add_runtime_dependency(%q<httparty>, ["> 0.6.0"])
  gem.add_development_dependency(%q<shoulda>, [">= 0"])
  gem.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
  gem.add_development_dependency(%q<mocha>, ["> 0.9.11"])
  gem.version       = Hoi::VERSION
end
